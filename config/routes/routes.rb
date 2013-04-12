Znaigorod::Application.routes.draw do
  mount Affiches::API => '/'
  mount ElVfsClient::Engine => '/'

  devise_for :users, :controllers => { :omniauth_callbacks =>  'omniauth_callbacks' }

  devise_scope :user do
    delete '/users/sign_out' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get 'cooperation'       => 'cooperation#index'
  get 'geocoder'          => 'geocoder#get_coordinates'
  get 'search'            => 'search#search',              :as => :search
  get 'webcams'           => 'webcams#index'

  resources :affiches,      :only => :index
  resources :saunas,        :only => :index

  resources :organizations, :only => [:index, :show] do
    get :in_bounding_box, :on => :collection

    resources :comments, :only => [:new, :create, :show]
    resources :user_ratings, :only => [:new, :create, :edit, :update, :show]
  end

  get 'photogalleries/:period/(*query)' => 'photogalleries#index',  :as => :photogalleries, :period => /all|month|week/

  Affiche.descendants.map{ |d| d.name.underscore }.each do |type|
    get  "#{type}/:#{type}_id/comments/new" => 'comments#new',    :as => "new_#{type}_comment"
    get  "#{type}/:#{type}_id/comments/:id" => 'comments#show',   :as => "#{type}_comment"
    post "#{type}/:#{type}_id/comments"     => 'comments#create', :as => "#{type}_comments"

    get  "#{type}/:#{type}_id/user_ratings/:id"          => 'user_ratings#show',     :as => "#{type}_user_rating"
    get  "#{type}/:#{type}_id/user_ratings/new"          => 'user_ratings#new',      :as => "new_#{type}_user_rating"
    post "#{type}/:#{type}_id/user_ratings"              => 'user_ratings#create',   :as => "#{type}_user_ratings"
    get  "#{type}/:#{type}_id/user_ratings/:id/edit"     => 'user_ratings#edit',     :as => "new_#{type}_user_rating"
    put  "#{type}/:#{type}_id/user_ratings/:id"          => 'user_ratings#update',   :as => "#{type}_user_ratings"

    get "#{type}/:id"                           => 'affiches#show',         :as => "#{type}"
    get "#{type.gsub('_','')}/:id"              => 'affiches#show',         :as => "#{type.gsub('_','')}"
  end

  Organization.basic_suborganization_kinds.each do |kind|
    get "/#{kind.pluralize}" => 'suborganizations#index', :as => kind.pluralize, :constraints => { :kind => kind }, :defaults => { :kind => kind }
  end
  get '/entertainments' => 'suborganizations#index', :as => :billiards, :constraints => { :kind => 'entertainments' }, :defaults => { :kind => 'entertainments' }

  resources :posts, :only => [:index, :show] do
    get :draft, :on => :collection, :as => :draft

    resources :comments, :only => [:new, :create, :show]
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
