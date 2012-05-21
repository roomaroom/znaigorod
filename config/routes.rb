Znaigorod::Application.routes.draw do
  namespace :manage do
    match 'geocoder' => 'geocoder#get_coordinates'

    resources :affiches, :only => [:index, :new]
    resources :organizations, :only => [:index, :new]

    [:eatings, :funnies].each do |res|
      resources res, :except => :show
    end

    [:concerts, :exhibitions, :movies, :parties, :spectacles, :sports_events].each do |res|
      resources res, :except => :show
    end

    root :to => 'organizations#index'
  end

  resources :affiches, :only => [:index, :show]
  resources :organizations, :only => [:index, :show]

  root :to => 'application#main_page'

  mount ElVfsClient::Engine => '/'
end
