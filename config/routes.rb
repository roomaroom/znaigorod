Znaigorod::Application.routes.draw do
  namespace :manage do
    match 'geocoder' => 'geocoder#get_coordinates'

    resources :affiches, :only => [:index, :new]
    resources :organizations, :except => :show

    [:concerts, :exhibitions, :movies, :parties, :spectacles].each do |res|
      resources res, :except => :show
    end

    root :to => 'organizations#index'
  end

  resources :affiches, :only => [:index, :show]
  resources :organizations, :only => [:index, :show]

  root :to => 'application#main_page'

  mount ElVfsClient::Engine => '/'
end
