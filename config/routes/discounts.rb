# encoding: utf-8

Znaigorod::Application.routes.draw do
  mount Discounts::API => '/'

  constraints subdomain: 'discounts' do
    Discount.classes_subtree.map(&:name).map(&:underscore).each do |type|
      # /discounts/[discount|certificate|coupon]
      #get "/#{type}" => 'discounts#index', :constraints => { :type => type }, :defaults => { :type => type }
      # /discounts/[discount|certificate|coupon]/[auto|beauty|sport|...]
      Discount.kind.values.each do |kind|
        get "/#{type}/#{kind}" => 'discounts#index', :constraints => { :kind => kind, :type => type }, :defaults => { :kind => kind, :type => type }
      end

      # comments
      resources type.pluralize, :only => [] do
        resources :comments, :only => [:new, :show, :create]
        resources :offers,   :only => [:new, :create]
      end
    end

    # /discounts/[auto|beauty|sport|...]
    Discount.kind.values.each do |kind|
      get "/#{kind}" => 'discounts#index', :constraints => { :kind => kind }, :defaults => { :kind => kind }
    end

    resources :discounts, :only => [:index, :show] do
      resources :members,  :only => [:index, :create, :destroy]
    end


    root to: 'discounts#index'

    get 'offered_discount/:id' => 'discounts#show', :as => :offered_discount
  end
end
