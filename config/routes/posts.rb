# encoding: utf-8

Znaigorod::Application.routes.draw do
  get "posts/with_gallery" => 'posts#index', :defaults => { :kind => 'with_gallery' }
  get "posts/with_video"   => 'posts#index', :defaults => { :kind => 'with_video' }

  Post.categories.values.each do |category|
    get "posts/#{category}" => 'posts#index', :constraints => { :category => category }, :defaults => { :category => category }

    get "posts/#{category}/with_gallery" => 'posts#index', :constraints => { :category => category }, :defaults => { :category => category, :kind => 'with_gallery' }
    get "posts/#{category}/with_video"   => 'posts#index', :constraints => { :category => category }, :defaults => { :category => category, :kind => 'with_video' }
  end

  resources :posts, :only => [:index, :show] do
    get :draft, :on => :collection, :as => :draft
    get 'liked' => 'votes#liked', :as => :liked

    put 'change_vote' => 'votes#change_vote', :as => :change_vote

    resources :comments, :only => [:new, :create, :show]
  end

  namespace :my do
    resources :posts do
      get :available_tags, :on => :collection
      get :link_with,      :on => :collection
      get :poster,         :on => :member, :as => :poster

      post :preview,       :on => :collection

      put 'publish' => 'posts#send_to_published', :on => :member, :as => :publish
      put 'draft'   => 'posts#send_to_draft',     :on => :member, :as => :draft

      resources :gallery_images, :except => [:show, :edit, :update]
    end
  end
end
