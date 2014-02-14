class ReviewsPresenter
  include ActiveAttr::MassAssignment

  class Parameters
    include Rails.application.routes.url_helpers
    include Singleton

    attr_accessor :type, :category, :order_by

    def params
      { :type => type, :category => category, :order_by => order_by }
    end

    def path(type: self.type, category: self.category, order_by: self.order_by)
      return reviews_path(:order_by => order_by) if type.blank? && category.blank?

      path = [type, category].compact.join('_')

      send "reviews_#{path}_path", :order_by => order_by
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
    attr_accessor :type

    def initialize
      @type = Parameters.instance.type
    end

    def available
      { nil => 'Все', 'article' => 'Обзоры', 'photo' => 'Фотообзоры', 'video' => 'Видеообзоры' }
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
        :path => Parameters.instance.path(type: nil, category: nil)
      )
    end

    def type_links
      available.except(nil).map do |value, title|
        Hashie::Mash.new(
          :title => title,
          :klass => value.dup.tap { |s| s << ' selected' if value == selected },
          :path => Parameters.instance.path(type: value)
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
      Review.categories.values
    end

    def links
      [all_link] + category_links
    end

    def more?
      return false if selected.blank?

      available.index(selected).to_i > 6
    end

    def human_titles
      Hash[Review.categories.options].invert
    end

    def all_link
      params = Parameters.instance.params.merge(:category => nil)

      Hashie::Mash.new(
        :value => nil,
        :title => 'ВСЕ ОБЗОРЫ',
        :klass => "all #{params[:type]}".tap { |s| s << ' selected' if category.blank? },
        :path => Parameters.instance.path(category: nil),
        :results_count => 99
      )
    end

    def category_links
      available.map do |category|
        #params = Parameters.instance.params.merge(:category => category)
        title = human_titles[category]

        Hashie::Mash.new(
          :value => category,
          :title => title,
          :klass => category.dup.tap { |s| s << ' selected' if category == selected },
          :path => Parameters.instance.path(category: category),
          :results_count => 99
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
          :klass => "#{value}".tap { |s| s << ' selected' if value == selected },
          :path => Parameters.instance.path(order_by: value),
        )
      end
    end
  end

  attr_accessor :type, :category,
                :order_by, :page, :per_page,
                :q, :advertisement, :with_advertisement

  attr_reader :type_filter, :category_filter, :order_by_filter

  def initialize(args)
    super(args)

    normalize_args
    store_parameters
    initialize_filters
    #initialize_advertisement
  end

  #def initialize_advertisement
    #@advertisement = Advertisement.new(list: 'discount', page: @page)
  #end

  def collection
    searcher.results
  end

  def with_advertisement?
    with_advertisement
  end

  def decorated_collection
    #@decorated_collection ||= begin
                                #list = collection.map { |item| DiscountDecorator.decorate item }

                                #advertisement.places_at(page).each do |ad|
                                  #list.insert(ad.position, ad)
                                #end if with_advertisement?

                                #list
                              #end
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
    @per_page ||= per_page.to_i.zero? ? 15 : per_page.to_i
  end

  def store_parameters
    %w(type category order_by).each { |p| Parameters.instance.send "#{p}=", send(p) }
  end

  def initialize_filters
    @type_filter     = TypeFilter.new
    @category_filter = CategoryFilter.new
    @order_by_filter = OrderByFilter.new
  end

  def searcher_params
    @searcher_params ||= {}.tap do |params|
      params[:type]             = type_filter.selected
      params[:category]         = category_filter.selected
      #params[:q]                = q if q.present?
      #params[:without]          = advertisement.discounts if with_advertisement?
    end
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:reviews, searcher_params).tap { |s|
      order_by_filter.random? ? s.order_by(:random) : s.send("order_by_#{order_by_filter.selected}")

      s.paginate page: page, per_page: per_page
    }
  end
end
