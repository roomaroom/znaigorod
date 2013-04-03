Znaigorod::Application.routes.draw do
  mount Affiches::API => '/'
  mount ElVfsClient::Engine => '/'

  get 'cooperation'       => 'cooperation#index'
  get 'geocoder'          => 'geocoder#get_coordinates'
  get 'search'            => 'search#search',             :as => :search
  get 'webcams'           => 'webcams#index'

  resources :affiches,      :only => :index
  resources :organizations, :only => [:index, :show]
  resources :saunas,        :only => :index

  get 'masterclass/:id'                 => 'affiches#show',         :as => :master_class
  get 'photogalleries/:period/(*query)' => 'photogalleries#index',  :as => :photogalleries, :period => /all|month|week/
  get 'sportsevent/:id'                 => 'affiches#show',         :as => :sports_event

  Affiche.descendants.each do |type|
    get "#{type.name.downcase}/:id" => 'affiches#show', :as => "#{type.name.downcase}"
    get "#{type.name.downcase}/:id/photogallery" => 'affiches#photogallery', :as => "#{type.name.downcase}_photogallery"
    get "#{type.name.downcase}/:id/trailer" => 'affiches#trailer', :as => "#{type.name.downcase}_trailer"
  end

  Organization.basic_suborganization_kinds.each do |kind|
    get "/#{kind.pluralize}" => 'suborganizations#index', :as => kind.pluralize, :constraints => { :kind => kind }, :defaults => { :kind => kind }
  end
  get '/entertainments' => 'suborganizations#index', :as => :billiards, :constraints => { :kind => 'entertainments' }, :defaults => { :kind => 'entertainments' }

  resources :posts, :only => [:index, :show] do
    get :draft, :on => :collection, :as => :draft
  end

  resources :contests, :only => :show do
    resources :works, :only => :show
  end

  get 'feedback' => 'feedback#new', :as => :new_feedback
  post 'feedback' => 'feedback#create', :as => :create_feedback

  constraints(Subdomain) do
    match '/' => 'organizations#show'
  end

  match "/auth/:provider/callback" => "manage/sessions#create"

  root :to => 'application#main_page'
end
