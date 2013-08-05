HasSearcher.create_searcher :similar_afisha do
  models :afisha

  scope do
    with(:last_showing_time).greater_than HasSearcher.cacheable_now
  end

  scope :with_images do
    with(:has_images, true)
  end
end

HasSearcher.create_searcher :similar_posts do
  models :post
end

HasSearcher.create_searcher :photoreport do
  models :attachment

  property :category
  property :tags

  scope :weekly do
    with(:created_at).greater_than 1.week.ago.beginning_of_day
  end

  scope :monthly do
    with(:created_at).greater_than 1.month.ago.beginning_of_day
  end

  scope do
    any_of do
      with(:type, 'GalleryImage')
      with(:type, 'GallerySocialImage')
    end
    facet(:category)
    facet(:tags)

    order_by :id, :desc

    with(:attachable_type, 'Afisha')
    with(:attachable_state, 'published')
  end

  scope :grouped do
    group :attachable_id_str
  end
end

HasSearcher.create_searcher :actual_organization do
  models :meal, :entertainment, :culture, :sauna

  property :meal_offer
  property :meal_category

  property :entertainment_category
  property :entertainment_offer

  property :culture_category
  property :culture_offer

  property :sauna_category
  property :sauna_offer

  scope do
    #adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_f}*:*" }
    order_by(:organization_total_rating, :desc)
  end
end


HasSearcher.create_searcher :organizations do
  models :organization

  property :location do |search|
    search.with(:location).in_bounding_box(
      [search_object.location[:ax], search_object.location[:ay]],
      [search_object.location[:bx], search_object.location[:by]]
    ) if search_object.location &&
      search_object.location[:ax] && search_object.location[:ax] &&
      search_object.location[:bx] && search_object.location[:bx]
  end

  scope :with_logotype do
    with(:logotyped, true)
  end

  scope :order_by_rating do
    order_by(:total_rating, :desc)
  end

  property :without do |search|
    if organization = Organization.find_by_id(search_object.without.to_i)
      search.without(organization)
    end
  end
end

HasSearcher.create_searcher :manage_organization do
  models :organization

  keywords :q

  property :status
  property :user_id
  property :suborganizations
end

HasSearcher.create_searcher :global do
  models :organization, :afisha, :post
  keywords :q do
    highlight :title_translit
    highlight :description_ru
    highlight :address_ru
    HitDecorator::ADDITIONAL_FIELDS.each do |field|
      if (Organization.instance_methods + Afisha.instance_methods + Post.instance_methods).include? :"#{field}_ru"
        highlight "#{field}_ru"
      else
        highlight field
      end
    end
    boost 1 do
      any_of do
        with(:last_showing_time).greater_than(HasSearcher.cacheable_now)
        with(:kind, ['organization'])
      end
    end
    boost(
      function {
        sum(
          div(:total_rating, Afisha.maximum(:total_rating)),
          div(:total_rating, Organization.maximum(:total_rating))
        )
      }
    )
  end
  scope do
    adjust_solr_params do |params|
      (params[:qf] || '').gsub! /\bterm_text\b/, ''
      params[:fl] = 'id score'
    end
  end
end
