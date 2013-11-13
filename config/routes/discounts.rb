# encoding: utf-8

Znaigorod::Application.routes.draw do
  mount Discounts::API => '/'

  (Discount.descendants << Discount).map(&:name).map(&:underscore).each do |type|
    # /discounts/[discount|certificate|coupon]
    get "discounts/#{type}" => 'discounts#index', :constraints => { :type => type }, :defaults => { :type => type }

    # /discounts/[discount|certificate|coupon]/[auto|beauty|sport|...]
    Discount.kind.values.each do |kind|
      get "discounts/#{type}/#{kind}" => 'discounts#index', :constraints => { :kind => kind, :type => type }, :defaults => { :kind => kind, :type => type }
    end
  end

  # /discounts/[auto|beauty|sport|...]
  Discount.kind.values.each do |kind|
    get "discounts/#{kind}" => 'discounts#index', :constraints => { :kind => kind }, :defaults => { :kind => kind }
  end

  resources :discounts, :only => [:index, :show] do
    resources :comments, :only => [:new, :show, :create]
    resources :members, :only => [:index, :create, :destroy]
  end
end
