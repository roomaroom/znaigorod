class QuestionsPresenter
  include ActiveAttr::MassAssignment

  class Parameters
    include Rails.application.routes.url_helpers
    include Singleton

    attr_accessor :category, :order_by, :type

    def params
      { :type => 'question', :category => category, :order_by => order_by }
    end

    def path(category: self.category, order_by: self.order_by)
      return questions_path if category.blank?

      send "questions_#{category}_path"
    end
  end

  class Counter
    def initialize(args)
      @args = args
    end

    def count
      HasSearcher.searcher(:reviews, @args).total_count
    end
  end

  class CategoryFilter
    attr_accessor :category

    alias :selected :category

    def initialize
      p '='*80
      p Parameters.instance.category
      @category = Parameters.instance.category
    end

    def available
      #@available ||= HasSearcher.searcher(:reviews).facet(:category).rows.map(&:value)
      @available ||= Question.categories.values
    end

    def links
      @links ||= [all_link] + category_links
    end

    def more?
      return false if selected.blank?

      available.index(selected).to_i > 6
    end

    def eighteen_plus?
      selected == 'eighteen_plus'
    end

    def human_titles
      Hash[Review.categories.options].invert
    end

    def all_link
      params = Parameters.instance.params.merge(:category => nil)

      Hashie::Mash.new(
        :value => nil,
        :title => params[:type]? I18n.t("activerecord.models.review.#{params[:type]}") : 'Все обзоры',
        :klass => "all #{params[:type]}".tap { |s| s << ' selected' if category.blank? },
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
      { 'creation' => 'Новизне', 'rating' => 'Рейтингу', 'commented' => 'Количеству комментариев' }
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
          :klass => "#{value}".tap { |s| s << ' selected' if value == selected },
          :path => Parameters.instance.path(order_by: value),
        )
      end
    end
  end

  attr_accessor :type, :category,
                :order_by, :page, :per_page

  attr_reader :category_filter, :order_by_filter

  def initialize(args)
    super(args)

    normalize_args
    store_parameters
    initialize_filters
  end

  def collection
    searcher.results
  end

  def total_count
    searcher.total_count
  end

  def current_count
    total_count - (@page * @per_page)
  end

  def decorated_collection
    @decorated_collection ||= ReviewDecorator.decorate(collection)
  end

  def page_title
    searcher_params[:category].present? ? I18n.t("meta.reviews.#{searcher_params[:category]}.title") : I18n.t('meta.reviews.title')
  end

  def meta_description
    I18n.t("meta.reviews.description", default: '')
  end

  def meta_keywords
    I18n.t("meta.reviews.keywords", default: '')
  end

  private

  def normalize_args
    @page     ||= 1
    @per_page ||= per_page.to_i.zero? ? 12 : per_page.to_i
  end

  def store_parameters
    %w(category order_by).each { |p| Parameters.instance.send "#{p}=", send(p) }
  end

  def initialize_filters
    @category_filter   ||= CategoryFilter.new
    @order_by_filter   ||= OrderByFilter.new
  end


  def searcher_params
    @searcher_params ||= {}.tap do |params|
      params[:type]             = 'question'
      params[:category]         = category_filter.selected
    end
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:reviews, searcher_params).tap { |s|
      order_by_filter.random? ? s.order_by(:random) : s.send("order_by_#{order_by_filter.selected}")

      s.paginate page: page, per_page: per_page
    }
  end
end
