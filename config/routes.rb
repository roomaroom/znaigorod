Znaigorod::Application.routes.draw do
  namespace :manage do
    match 'geocoder' => 'geocoder#get_coordinates'

    resources :affiches, :only => [:index, :new]
    resources :organizations, :except => :show

    %w[concerts movies].each do |type|
      resources type.to_sym, :except => :show
    end

    root :to => 'organizations#index'
  end

  resources :affiches, :only => [:index, :show]
  resources :organizations, :only => [:index, :show]

  root :to => 'application#main_page'

  mount ElVfsClient::Engine => '/'
end
