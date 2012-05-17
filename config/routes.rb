AFFICHE_TYPES = %w[concerts movies]

Znaigorod::Application.routes.draw do
  namespace :manage do
    match 'geocoder' => 'geocoder#get_coordinates'

    resources :affiches, :only => [:index, :new]
    resources :organizations, :except => :show

    AFFICHE_TYPES.each do |type|
      resources type.to_sym, :except => :show
    end

    root :to => 'organizations#index'
  end

  resources :affiches, :only => [:index, :show]
  resources :organizations, :only => [:index, :show]

  AFFICHE_TYPES.each do |type|
    resources type.to_sym, :only => :index
  end

  root :to => 'application#main_page'

  mount ElVfsClient::Engine => '/'
end
