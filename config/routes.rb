Znaigorod::Application.routes.draw do
  namespace :manage do
    match 'geocoder' => 'geocoder#get_coordinates'
    resources :organizations
    root :to => 'organizations#index'
  end

  resources :organizations, :only => [:index, :show]
  root :to => 'application#stub'
end
