# encoding: utf-8

Znaigorod::Application.routes.draw do
  mount Discounts::API => '/'

  # /discounts/[discount|certificate|coupon]
  [Discount, Certificate, Coupon].map(&:name).map(&:underscore).each do |type|
    get "discounts/#{type}" => 'discounts#index', :constraints => { :type => type }, :defaults => { :type => type }
  end

  # /discounts/[auto|beauty|sport|...]
  Discount.kind.values.each do |kind|
    get "discounts/#{kind}" => 'discounts#index', :constraints => { :kind => kind }, :defaults => { :kind => kind }
  end

  # /discounts/[discount|certificate|coupon]/[auto|beauty|sport|...]
  [Discount, Certificate, Coupon].map(&:name).map(&:underscore).each do |type|
    Discount.kind.values.each do |kind|
      get "discounts/#{type}/#{kind}" => 'discounts#index', :constraints => { :kind => kind, :type => type }, :defaults => { :kind => kind, :type => type }
    end
  end

  resources :discounts, :only => [:index, :show] do
    resources :comments, :only => [:new, :show, :create]
    resources :members, :only => [:index, :create, :destroy]
  end
end
