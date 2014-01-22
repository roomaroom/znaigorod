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
      return posts_path(:order_by => order_by) if kind.blank? && category.blank?

      path = [category, kind].compact.join('_')

      send "posts_#{path}_path", :order_by => order_by
    end
  end

  class Counter
    def initialize(args)
      @args = args
    end

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
        :klass => nil == selected ? ' selected' : '',
        :path => Parameters.instance.path(kind: nil)
      )
    end

    def kind_links
      available.except(nil).map do |value, title|
        Hashie::Mash.new(
          :title => title,
          :klass => value.dup.tap { |s| s << ' selected' if value == selected },
          :path => Parameters.instance.path(kind: value)
        )
      end
    end
  end

  class CategoryFilter
    attr_accessor :category

    alias :selected :category

    def initialize
      @category = Parameters.instance.category
    end

    def available
      Post.categories.values
    end

    def links
      [all_link] + category_links
    end

    def more?
      return false if selected.blank?

      available.index(selected) > 6
    end

    def human_titles
      Hash[Post.categories.options].invert
    end

    def all_link
      params = Parameters.instance.params.merge(:category => nil)

      Hashie::Mash.new(
        :value => nil,
        :title => 'Все обзоры',
        :klass => category.blank? ? 'all selected' : 'all',
        :path => Parameters.instance.path(category: nil),
        :results_count => Counter.new(params).count
      )
    end

    def category_links
      available.map do |category|
        params = Parameters.instance.params.merge(:category => category)
        title = human_titles[category]

        Hashie::Mash.new(
          :value => category,
          :title => title,
          :klass => category.dup.tap { |s| s << ' selected' if category == selected },
          :path => Parameters.instance.path(category: category),
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

  attr_accessor :kind, :category,
                :order_by, :page, :per_page, :q

  attr_reader :kind_filter, :category_filter, :order_by_filter

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
    "Find me at #{__FILE__}:#{__LINE__}"
  end

  # TODO
  def meta_description
    "Find me at #{__FILE__}:#{__LINE__}"
  end

  # TODO
  def meta_keywords
    "Find me at #{__FILE__}:#{__LINE__}"
  end

  private

  def normalize_args
    @page     ||= 1
    @per_page ||= per_page.to_i.zero? ? 15 : per_page.to_i
  end

  def store_parameters
    %w(kind category order_by).each { |p| Parameters.instance.send "#{p}=", send(p) }
  end

  def initialize_filters
    @kind_filter     = KindFilter.new
    @category_filter = CategoryFilter.new
    @order_by_filter = OrderByFilter.new
  end

  def searcher_params
    @searcher_params ||= {}.tap do |params|
      params[:kind]     = kind_filter.selected
      params[:category] = category_filter.selected
    end
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:posts_new, searcher_params).tap { |s|
      s.send("order_by_#{order_by_filter.selected}")

      s.paginate page: page, per_page: per_page
    }
  end
end
