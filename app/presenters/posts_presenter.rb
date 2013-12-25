# encoding: utf-8

class PostsPresenter
  include ActiveAttr::MassAssignment

  class Parameters
    include Rails.application.routes.url_helpers
    include Singleton

    attr_accessor :type, :kind, :organization_id, :order_by

    def params
      { :type => type, :kind => kind, :order_by => order_by }
    end

    def organization_id?
      organization_id.present?
    end

    # TODO
    def path(type: type, kind: kind, order_by: order_by)
      posts_path
    end
  end

  class Counter
    def initialize(args)
      @args = args
    end

    # TODO
    def count
      HasSearcher.searcher(:discounts, @args).total_count
    end
  end

  class TypeFilter
    attr_accessor :type

    def initialize
      @type = Parameters.instance.type
    end

    # TODO
    def available
      { nil => 'Все', 'discount' => 'Обзоры', 'coupon' => 'С галереей', 'certificate' => 'С видео' }
    end

    def selected
      available.keys.compact.include?(type) ? type : available.keys.first
    end

    def links
      [all_link] + type_links
    end

    private

    def all_link
      Hashie::Mash.new(
        :title => 'Все',
        :klass => ''.tap { |s| s << ' selected' if nil == selected },
        :path => Parameters.instance.path(type: nil, kind: nil)
      )
    end

    def type_links
      available.except(nil).map do |value, title|
        Hashie::Mash.new(
          :title => title,
          :klass => "#{value}".tap { |s| s << ' selected' if value == selected },
          :path => Parameters.instance.path(type: value)
        )
      end
    end
  end

  class KindFilter
    attr_accessor :kind

    def initialize
      @kind = Parameters.instance.kind
    end

    def available
      Post.categories.values
    end

    def selected
      kind
    end

    def links
      [all_link] + kind_links
    end

    def more?
      return false if selected.blank?

      available.index(selected) > 6
    end

    def human_titles
      Hash[Post.categories.options].invert
    end

    def all_link
      params = Parameters.instance.params.merge(:kind => nil)

      Hashie::Mash.new(
        :value => nil,
        :title => 'Все обзоры',
        :klass => "all #{params[:type]}".tap { |s| s << ' selected' if kind.blank? },
        :path => Parameters.instance.path(kind: nil),
        :results_count => Counter.new(params).count
      )
    end

    def kind_links
      available.map do |kind|
        params = Parameters.instance.params.merge(:kind => kind)
        title = human_titles[kind]

        Hashie::Mash.new(
          :value => kind,
          :title => title,
          :klass => "#{kind}".tap { |s| s << ' selected' if kind == selected },
          :path => Parameters.instance.path(kind: kind),
          :results_count => Counter.new(params).count
        )
      end
    end
  end

  class OrderByFilter
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

    def random?
      order_by == 'random'
    end

    def links
      available.map do |value, title|
        Hashie::Mash.new(
          :value => value,
          :title => title,
          :klass => "#{value}".tap { |s| s << " selected" if value == selected },
          :params => Parameters.instance.params.merge(:order_by => value).delete_if { |_, v| v.blank? },
          :path => Parameters.instance.path(order_by: value),
        )
      end
    end
  end

  attr_accessor :type, :kind, :organization_id,
                :order_by, :page, :per_page, :q

  attr_reader :type_filter, :kind_filter, :order_by_filter

  def initialize(args)
    super(args)

    normalize_args
    store_parameters
    initialize_filters
  end

  # TODO
  def collection
    Post.scoped.page(1)
  end

  def decorated_collection
    @decorated_collection ||= PostDecorator.decorate(collection)
  end

  def page_title
    searcher_params[:kind].present? ? I18n.t("meta.discount.#{searcher_params[:kind]}.title") : I18n.t('meta.discount.title')
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
    @per_page ||= per_page.to_i.zero? ? 15 : per_page.to_i
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
      params[:q] =              q if q.present?
    end
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:discounts, searcher_params).tap { |s|
      order_by_filter.random? ? s.order_by(:random) : s.send("order_by_#{order_by_filter.selected}")

      s.paginate page: page, per_page: per_page
    }
  end
end
