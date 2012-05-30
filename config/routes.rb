Znaigorod::Application.routes.draw do
  namespace :manage do
    get 'geocoder' => 'geocoder#get_coordinates'

    resources :affiches, :only => [:index, :new]
    resources :organizations, :only => [:index, :new]

    Organization.descendants.each do |type|
      resources type.name.underscore.pluralize, :except => :show
    end

    Affiche.descendants.each do |type|
      resources type.name.underscore.pluralize, :except => :show
    end

    root :to => 'organizations#index'
  end

  get 'search' => 'search#index'

  resources :affiches, :only => [:index, :show]
  Organization.descendants.each do |type|
    resources type.name.underscore.pluralize, :except => :show
  end

  root :to => 'application#main_page'

  mount ElVfsClient::Engine => '/'
end
