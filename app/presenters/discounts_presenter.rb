# encoding: utf-8

class DiscountsPresenter
  include ActiveAttr::MassAssignment

  class Parameters
    include Singleton

    attr_accessor :type, :kind, :organization_id, :order_by

    def params
      { :type => type, :kind => kind, :order_by => order_by }
    end

    def organization_id?
      organization_id.present?
    end
  end

  class Counter
    def initialize(args)
      @args = args
    end

    def count
      HasSearcher.searcher(:discounts, @args).total_count
    end
  end

  class TypeFilter
    include Rails.application.routes.url_helpers

    attr_accessor :type

    def initialize
      @type = Parameters.instance.type
    end

    def available
      { nil => 'Все', 'discount' => 'Скидки', 'coupon' => 'Купоны', 'certificate' => 'Сертификаты' }
    end

    def selected
      available.keys.compact.include?(type) ? type : available.keys.first
    end

    def links
      available.map do |value, title|
        Hashie::Mash.new(
          :title => title,
          :klass => "#{value}".tap { |s| s << ' selected' if value == selected },
          :path => discounts_path(Parameters.instance.params.merge(:type => value))
        )
      end
    end
  end

  class KindFilter
    include Rails.application.routes.url_helpers

    attr_accessor :kind

    def initialize
      @kind = Parameters.instance.kind
    end

    def available
      Hashie::Mash.new(Hash[Discount.kind.options].invert)
    end

    def selected
      kind
    end

    def links
      [all_link] + kind_links
    end

    private

    def all_link
      params = Parameters.instance.params.merge(:kind => nil)

      Hashie::Mash.new(
        :value => nil,
        :title => 'Все скидки',
        :klass => "all".tap { |s| s << ' selected' if kind.blank? },
        :path => discounts_path(params),
        :results_count => Counter.new(params).count
      )
    end

    def kind_links
      available.map do |value, title|
        params = Parameters.instance.params.merge(:kind => value)

        Hashie::Mash.new(
          :value => value,
          :title => title,
          :klass => "#{value}".tap { |s| s << ' selected' if value == selected },
          :path => discounts_path(params),
          :results_count => Counter.new(params).count
        )
      end
    end
  end

  class OrderByFilter
    include Rails.application.routes.url_helpers

    attr_accessor :order_by

    def initialize
      @order_by = Parameters.instance.order_by
    end

    def available
      { 'creation' => 'Новизне', 'rating' => 'Рейтингу' }
    end

    def selected
      available.keys.compact.include?(order_by) ? order_by : available.keys.first
    end

    def links
      available.map do |value, title|
        Hashie::Mash.new(
          :value => value,
          :title => title,
          :klass => "#{value}".tap { |s| s << " selected" if value == selected },
          :params => Parameters.instance.params.merge(:order_by => value).delete_if { |_, v| v.blank? },
          :path => discounts_path(Parameters.instance.params.merge(:order_by => value))
        )
      end
    end
  end

  attr_accessor :type, :kind, :organization_id,
                :order_by, :page, :per_page

  attr_reader :type_filter, :kind_filter, :order_by_filter

  def initialize(args)
    super(args)

    normalize_args
    store_parameters
    initialize_filters
  end

  def collection
    searcher.results
  end

  def page_title
    title = I18n.t("meta.discount.title")
  end

  def meta_description
    I18n.t("meta.discount.description", default: '')
  end

  def meta_keywords
    I18n.t("meta.discount.keywords", default: '')
  end

  private

  def normalize_args
    @page     ||= 1
    @per_page = 15
  end

  def store_parameters
    %w(type kind organization_id order_by).each { |p| Parameters.instance.send "#{p}=", send(p) }
  end

  def initialize_filters
    @type_filter     = TypeFilter.new
    @kind_filter     = KindFilter.new
    @order_by_filter = OrderByFilter.new
  end

  def searcher_params
    @searcher_params ||= {}.tap do |params|
      params[:type]             = type_filter.selected
      params[:kind]             = kind_filter.selected
      params[:organization_ids] = [Parameters.instance.organization_id] if Parameters.instance.organization_id?
    end
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:discounts, searcher_params).tap { |s|
      s.send "order_by_#{order_by_filter.selected}"
      s.paginate(page: page, per_page: per_page)
    }
  end
end
