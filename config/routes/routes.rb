# encoding: utf-8

require 'sidekiq/web'

Znaigorod::Application.routes.draw do
  mount ElVfsClient::Engine => '/'
  mount Sidekiq::Web, at: "/sidekiq"

  devise_for :users, :controllers => { :omniauth_callbacks =>  'omniauth_callbacks' }

  devise_scope :user do
    delete '/users/sign_out' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get 'away'    => 'away#go'
  get 'sitemap' => 'sitemap#show'

  %w[services benefit statistics our_customers extra_catalogs ticket_sales].each do |method|
    get method => "cooperation##{method}"
  end

  get 'feedback' => 'feedback#show'

  get '/cooperation'    => redirect('/services')
  get 'accounts_search' => 'accounts_search#show',         :as => :accounts_search
  get 'geo_info'        => 'geocoder#geo_info'
  get 'geocoder'        => 'geocoder#get_coordinates'
  get 'search'          => 'search#search',                :as => :search
  get 'webcams'         => 'webcams#index'
  get 'yamp_geocoder'   => 'geocoder#get_yamp_coordinates'
  get '/paradnevest2014'    => redirect('/photogalleries/parad-nashestvie-nevest-2014')
  get '/%D0%BF%D0%B0%D1%80%D0%B0%D0%B4%D0%BD%D0%B5%D0%B2%D0%B5%D1%81%D1%822014'    => redirect('/photogalleries/parad-nashestvie-nevest-2014')

  get 'inviteables_search' => 'inviteables_search#show'

  resources :invitations
  resources :banners, :only => [:show]
  resources :comments_images, :only => [:create, :destroy]

  resources :afisha, :only => [], :controller => 'afishas' do
    resources :comments, :only => [:new, :show, :create]
    resources :visits, :only => [:index, :create, :show, :destroy]

    resources :invitations
    resources :promote_afisha_payments, :only => :create

    get 'liked'        => 'votes#liked',         :as => :liked
    get 'photogallery' => 'afisha#photogallery', :as => :photogallery
    get 'trailer'      => 'afisha#trailer',      :as => :trailer

    put 'change_vote'    => 'votes#change_vote',     :as => :change_vote
    put 'destroy_visits' => 'visits#destroy_visits', :as => :destroy_visits
  end

  get '/afisha' => 'afishas#index', :as => :afisha_index, :controller => 'afishas'
  get '/afisha/:id' => 'afishas#show', :as => :afisha_show, :controller => 'afishas'

  get 'accounts_search' => 'accounts_search#show',         :as => :accounts_search
  get 'geocoder' => 'geocoder#get_coordinates'
  get 'search' => 'search#search',                :as => :search
  get 'yamp_geocoder' => 'geocoder#get_yamp_coordinates'
  get 'yamp_geocoder_photo' => 'geocoder#get_yamp_house_photo'

  resources :comments, :only => [] do
    put 'change_vote' => 'votes#change_vote', :as => :change_vote
    put 'liked' => 'votes#liked', :as => :liked
  end

  resources :organizations, :only => [:index, :show] do
    get :in_bounding_box, :on => :collection
    get :details_for_balloon, :on => :member
    put 'change_vote' => 'votes#change_vote', :as => :change_vote
    put 'destroy_visits' => 'visits#destroy_visits', :as => :destroy_visits
    get 'liked' => 'votes#liked', :as => :liked

    resources :comments, :only => [:new, :create, :show]
    resources :visits
    resources :invitations

    resources :user_ratings, :only => [:new, :create, :edit, :update, :show]
  end

  get '/tsu' => redirect('/contests/ya-v-tgu-i-na-znaygorode')
  resources :contests, :only => [:index, :show] do
    resources :works, :only => [:new, :create, :show] do
      put 'change_vote' => 'votes#change_vote', :as => :change_vote
      get 'liked' => 'votes#liked', :as => :liked
    end
  end

  resources :photogalleries, :only => [:index, :show] do
    resources :works, :only => [:new, :create, :show, :destroy, :update] do
      get 'add' => 'works#add', on: :collection
      post 'add' => 'works#add', on: :collection
      put 'change_vote' => 'votes#change_vote', :as => :change_vote
      get 'liked' => 'votes#liked', :as => :liked
    end
  end

  resources :works, :only => [] do
    resources :comments, :only => [:new, :create, :show]
  end

  resources :adverts, :only => [:index, :show]

  resources :service_payments, :only => [:new, :create]

  resources :webcams, :only => [:index, :show]

  match '/' => redirect{|p, req| "#{req.url.sub(req.subdomain+'.', '')}organizations/#{Organization.find_by_subdomain(req.subdomain).slug}"}, :constraints => lambda{|r| r.subdomain.present? && Organization.pluck(:subdomain).uniq.delete_if{|s| s.nil? || s.blank?}.include?(r.subdomain) }

  match "/auth/:provider/callback" => "manage/sessions#create"

  post '/promotions' => 'promotions#show'

  get '/getmvote' => 'sms_votes#index'

  root :to => 'main_page#show'
end
