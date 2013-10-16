# encoding: utf-8

class DiscountsPresenter
  include ActiveAttr::MassAssignment

  class Parameters
    include Singleton

    attr_accessor :type, :kind, :order_by

    def params
      { :type => type, :kind => kind, :order_by => order_by }
    end
  end

  class TypeFilter
    include Rails.application.routes.url_helpers

    attr_accessor :type

    def initialize(type)
      @type = type
      Parameters.instance.type = selected
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
          :klass => "#{value}".tap { |s| s << " selected" if value == selected },
          :path => discounts_path(Parameters.instance.params.merge(:type => value))
        )
      end
    end
  end

  class KindFilter
    include Rails.application.routes.url_helpers

    attr_accessor :kind

    def initialize(kind)
      @kind = kind
      Parameters.instance.kind = selected
    end

    def available
      Hashie::Mash.new(Hash[Discount.kind.options].invert)
    end

    def selected
      kind
    end

    def links
      available.map do |value, title|
        Hashie::Mash.new(
          :value => value,
          :title => title,
          :klass => "#{value}".tap { |s| s << " selected" if value == selected },
          :path => discounts_path(Parameters.instance.params.merge(:kind => value))
        )
      end
    end
  end

  class OrderByFilter
    include Rails.application.routes.url_helpers

    attr_accessor :order_by

    def initialize(order_by)
      @order_by = order_by
      Parameters.instance.order_by = selected
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
          :path => discounts_path(Parameters.instance.params.merge(:order_by => value))
        )
      end
    end
  end

  attr_accessor :type, :kind,
                :order_by, :page, :per_page

  attr_reader :type_filter, :kind_filter, :order_by_filter

  def initialize(args)
    super(args)

    normalize_args
    initialize_filters
  end

  def collection
    searcher.results
  end

  private

  def normalize_args
    @page     ||= 1
    @per_page = 10
  end

  def initialize_filters
    @type_filter     = TypeFilter.new(type)
    @kind_filter     = KindFilter.new(kind)
    @order_by_filter = OrderByFilter.new(order_by)
  end

  def searcher_params
    @searcher_params ||= {}.tap do |params|
      params[:type] = type_filter.selected
    end
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:discounts, searcher_params).tap { |s|
      s.send "order_by_#{order_by_filter.order_by}"
      s.paginate(page: page, per_page: per_page)
    }
  end
end
