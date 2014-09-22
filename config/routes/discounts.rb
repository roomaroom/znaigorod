# encoding: utf-8

Znaigorod::Application.routes.draw do
  mount Discounts::API => '/'

  constraints subdomain: 'discounts' do

    Discount.classes_subtree.map(&:name).map(&:underscore).each do |type|
      # /[discount|certificate|coupon] not work yet
      get "/#{type}" => 'discounts#index', :constraints => { :type => type }, :defaults => { :type => type }
      # /[discount|certificate|coupon]/[auto|beauty|sport|...]
      Discount.kind.values.each do |kind|
        get "/#{type}/#{kind}" => 'discounts#index', :constraints => { :kind => kind, :type => type }, :defaults => { :kind => kind, :type => type }
      end

      # comments
      resources type.pluralize, :only => [] do
        resources :comments, :only => [:new, :show, :create]
        resources :offers,   :only => [:new, :create]
      end
    end

    # /[auto|beauty|sport|...]
    Discount.kind.values.each do |kind|
      get "/#{kind}" => 'discounts#index', :constraints => { :kind => kind }, :defaults => { :kind => kind }
    end

    get ':id' => 'discounts#show', :as => :discount_show
    get '/' => 'discounts#index', :as => :discounts

    resources :discounts, :only => [:index, :show] do
      resources :members,  :only => [:index, :create, :destroy]
    end

    get 'offered_discount/:id' => 'discounts#show', :as => :offered_discount_show
  end
end
