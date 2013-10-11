# encoding: utf-8

class DiscountsPresenter
  include ActiveAttr::MassAssignment

  class TypeFilter
    include Rails.application.routes.url_helpers

    attr_accessor :type

    def initialize(type)
      @type = type
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
          :path => discounts_path(:type => value)
        )
      end
    end
  end

  class KindFilter
    include Rails.application.routes.url_helpers

    attr_accessor :kind

    def initialize(kind)
      @kind = kind
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
          :class => "#{value}".tap { |s| s << " selected" if value == selected },
          :path => discounts_path(:kind => value)
        )
      end
    end
  end

  attr_accessor :type, :kind,
                :order_by, :page, :per_page

  attr_reader :type_filter, :kind_filter

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
    @type_filter = TypeFilter.new(type)
    @kind_filter = KindFilter.new(kind)
  end

  def searcher_params
    @searcher_params ||= {}.tap do |params|
      params[:type] = type_filter.selected
    end
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:discounts, searcher_params).tap { |s|
      # s.send "order_by_#{order_by_filter.order_by}"
      s.paginate(page: page, per_page: per_page)
    }
  end
end
