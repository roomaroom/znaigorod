Znaigorod::Application.routes.draw do
  namespace :manage do
    match 'geocoder' => 'geocoder#get_coordinates'
    resources :organizations
    resources :affiches
    root :to => 'organizations#index'
  end

  resources :organizations, :only => [:index, :show]
  resources :affiches, :only => [:index, :show]

  root :to => 'application#main_page'
end
