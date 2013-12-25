# encoding: utf-8

class PostsPresenter
  include ActiveAttr::MassAssignment

  class Parameters
    include Rails.application.routes.url_helpers
    include Singleton

    attr_accessor :kind, :category, :order_by

    def params
      { :kind => kind, :category => category, :order_by => order_by }
    end

    def path(kind: kind, category: category, order_by: order_by)
      posts_path(:kind => kind, :category => category, :order_by => order_by)
    end
  end

  class Counter
    def initialize(args)
      @args = args
    end

    # TODO
    def count
      HasSearcher.searcher(:posts_new, @args).total_count
    end
  end

  class KindFilter
    attr_accessor :kind

    def initialize
      @kind = Parameters.instance.kind
    end

    def available
      { nil => 'Все', 'with_gallery' => 'С галереей', 'with_video' => 'С видео' }
    end

    def selected
      available.keys.compact.include?(kind) ? kind : available.keys.first
    end

    def links
      [all_link] + kind_links
    end

    private

    def all_link
      Hashie::Mash.new(
        :title => 'Все',
        :klass => ''.tap { |s| s << ' selected' if nil == selected },
        :path => Parameters.instance.path(kind: nil)
      )
    end

    def kind_links
      available.except(nil).map do |value, title|
        Hashie::Mash.new(
          :title => title,
          :klass => "#{value}".tap { |s| s << ' selected' if value == selected },
          :path => Parameters.instance.path(kind: value)
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

    def links
      available.map do |value, title|
        Hashie::Mash.new(
          :value => value,
          :title => title,
          :klass => "#{value}".tap { |s| s << ' selected' if value == selected },
          :path => Parameters.instance.path(order_by: value)
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

  def collection
    searcher.results
  end

  def decorated_collection
    @decorated_collection ||= PostDecorator.decorate(collection)
  end

  # TODO
  def page_title
    searcher_params[:kind].present? ? I18n.t("meta.discount.#{searcher_params[:kind]}.title") : I18n.t('meta.discount.title')
  end

  # TODO
  def meta_description
    I18n.t("meta.discount.description", default: '')
  end

  # TODO
  def meta_keywords
    I18n.t("meta.discount.keywords", default: '')
  end

  private

  def normalize_args
    @page     ||= 1
    @per_page ||= per_page.to_i.zero? ? 15 : per_page.to_i
  end

  def store_parameters
    %w(kind order_by).each { |p| Parameters.instance.send "#{p}=", send(p) }
  end

  def initialize_filters
    @kind_filter     = KindFilter.new
    @order_by_filter = OrderByFilter.new
  end

  def searcher_params
    @searcher_params ||= {}.tap do |params|
      params[:kind] = kind_filter.selected
    end
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:posts_new, searcher_params).tap { |s|
      s.send("order_by_#{order_by_filter.selected}")

      s.paginate page: page, per_page: per_page
    }
  end
end

