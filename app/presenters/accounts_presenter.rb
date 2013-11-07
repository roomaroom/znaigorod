# encoding: utf-8

class AccountsPresenter

  class GenderFilter
    attr_accessor :gender

    def initialize(gender)
      @gender = available_values.keys.include?(gender) ? gender : available_values.keys.first
    end

    def self.available_values
      { 'undefined' => 'Все пользователи', 'female' => 'Девушки', 'male' => 'Парни' }
    end

    def available_values
      self.class.available_values
    end

    available_values.each do |value, _|
      define_method "#{value}_selected?" do
        gender == value
      end
    end

    def used?
      gender != 'undefined'
    end
  end

  class ActsAsFilter
    attr_accessor :acts_as

    def initialize(acts_as)
      @acts_as = available_values.keys.include?(acts_as) ? acts_as : available_values.keys.first
    end

    def self.available_values
      { 'all' => 'Все', 'inviter' => 'Приглашают', 'invited' => 'Ждут приглашения' }
    end

    def available_values
      self.class.available_values
    end

    available_values.each do |value, _|
      define_method "#{value}_selected?" do
        acts_as == value
      end
    end

    def used?
      @acts_as != 'all'
    end
  end

  class CategoryFilter
    attr_accessor :category, :available_values

    def initialize(category)
      @available_values = Values.instance.invitation.categories
      @category  = @available_values.include?(category) ? category : nil
    end

    def used?
      @category.present?
    end
  end

  class OrderByFilter
    attr_accessor :order_by

    def initialize(order_by)
      @order_by = available_values.keys.include?(order_by) ? order_by : available_values.keys.first
    end

    def self.available_values
      { 'creation' => 'Новизне', 'friendable' => 'Популярности', 'activity' => 'Активности' }
    end

    def available_values
      self.class.available_values
    end

  end

  include ActiveAttr::MassAssignment

  attr_accessor :gender, :with_avatar, :acts_as,
                :category, :order_by, :page, :per_page

  attr_reader :gender_filter, :acts_as_filter, :category_filter, :order_by_filter

  def initialize(args)
    super(args)

    normalize_args
    initialize_filters
  end

  def gender_links
    @gender_links ||= [].tap do |links|
      gender_filter.available_values.each do |value, caption|
        links << {
          title: caption,
          klass: value,
          url: 'accounts_path',
          parameters: searcher_parameters(gender: value == 'undefined' ? nil : value),
          selected: gender_filter.gender == value
        }
      end
    end
  end

  def acts_as_links
    @acts_as_links ||= [].tap do |links|
      acts_as_filter.available_values.each do |value, caption|
        links << {
          title: caption,
          klass: value,
          url: 'accounts_path',
          parameters: searcher_parameters(acts_as: value == 'all' ? nil : value),
          selected: acts_as_filter.acts_as == value
        }
      end
    end
  end

  def categories_links
    @categories_links ||= [].tap do |links|
      category_filter.available_values.each do |value|
        links << {
          title: value,
          klass: value.from_russian_to_param,
          url: 'accounts_path',
          parameters: searcher_parameters(category: value),
          selected: category_filter.category == value,
          count: count(category: value)
        }
      end
      links.sort! {|a,b| b[:count] <=> a[:count]}
    end
  end

  def order_by_links
    @order_by_links ||= [].tap do |links|
      order_by_filter.available_values.each do |value, caption|
        links << {
          title: caption,
          klass: value,
          url: 'accounts_path',
          parameters: searcher_parameters(order_by: value),
          selected: order_by_filter.order_by == value,
        }
      end
    end
  end

  def searcher_parameters(hash = {})
    {
      gender: gender_filter.used? ? gender_filter.gender : nil,
      acts_as: acts_as_filter.used? ? acts_as_filter.acts_as : nil,
      category: category_filter.used? ? category_filter.category : nil,
      with_avatar: with_avatar ? true : nil
    }.merge(hash).select {|k,v| v}
  end

  def collection
    searcher.results
  end

  def page_title
    if gender_filter.used?
      I18n.t("meta.account.#{gender_filter.gender}.title")
    else
      I18n.t('meta.account.title')
    end

    if category_filter.used?
      I18n.t("meta.account.#{category_filter.category}.title")
    else
      I18n.t('meta.account.title')
    end
  end

  def count(params)
    HasSearcher.searcher(:accounts, searcher_parameters(params)).total
  end

  private

  def initialize_filters
    @acts_as_filter  ||= ActsAsFilter.new(acts_as)
    @category_filter ||= CategoryFilter.new(category)
    @gender_filter   ||= GenderFilter.new(gender)
    @order_by_filter ||= OrderByFilter.new(order_by)
  end

  def normalize_args
    @page               ||= 1
    @per_page           = 18
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:accounts, searcher_parameters).tap { |s|
      s.send "order_by_#{order_by_filter.order_by}"
      s.paginate(page: page, per_page: per_page)
    }
  end
end
