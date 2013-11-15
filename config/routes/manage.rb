# encoding: utf-8

Znaigorod::Application.routes.draw do
  namespace :manage do
    namespace :statistics do
      resources :payments,     :only => :index
      resources :reservations, :only => :update
      resources :sms_claims,   :only => :index
    end

    post 'red_cloth' => 'red_cloth#show'

    resources :comments,  :only => [:index, :destroy]
    resources :search,    :only => :index
    resources :sessions,  :only => [:new, :create, :destroy]

    resources :afisha, :except => [:index, :show], :controller => 'afishas' do
      get ':by_state' => 'afishas#index', :on => :collection, :as => :by_state, :constraints => { :by_state => /#{Afisha.state_machine.states.map(&:name).join('|')}/ }
      get ':by_kind' => 'afishas#index', :on => :collection, :as => :by_kind, :constraints => { :by_kind => /#{Afisha.kind.values.map(&:pluralize).join('|')}/ }
      put 'fire_event_state/:event' => 'afishas#fire_state_event', :on => :member, :as => :fire_state_event

      get 'poster' => 'afishas#poster', :on => :member, :as => :poster
      put 'poster' => 'afishas#poster', :on => :member, :as => :poster

      delete 'destroy_image', :on => :member, :as => :destroy_image

      resources :gallery_files,  :except => [:index, :show] do
        delete 'destroy_file', :on => :member, :as => :destroy_file
      end
      resources :gallery_images, :except => [:index, :show] do
        delete 'destroy_file', :on => :member, :as => :destroy_file
      end
      resources :gallery_social_images, :except => [:index, :show] do
        delete 'destroy_all', :on => :collection, :as => :destroy_all
      end
      resources :tickets
    end

    get "/afisha" => "afishas#index", :as => :afisha_index, :controller => 'afishas'
    get "/afisha/:id" => "afishas#show", :as => :afisha_show, :controller => 'afishas'

    resources :contests do
      resources :works, :except => [:index, :show]
    end

    resources :certificates,      :except => [:index, :show, :destroy]
    resources :coupons,           :except => [:index, :show, :destroy]
    resources :offered_discounts, :except => [:index, :show, :destroy]

    resources :discounts do
      get ':by_state' => 'discounts#index', :on => :collection, :as => :by_state, :constraints => { :by_state => /#{Discount.state_machine.states.map(&:name).join('|')}/ }
      get ':by_kind' => 'discounts#index', :on => :collection, :as => :by_kind, :constraints => { :by_kind => /#{Discount.kind.values.map(&:pluralize).join('|')}/ }
      get 'poster' => 'discounts#poster', :on => :member, :as => :poster
      put 'poster' => 'discounts#poster', :on => :member, :as => :poster

      put 'fire_event_state/:event' => 'discounts#fire_state_event', :on => :member, :as => :fire_state_event
    end

    get 'discount_statistics' => 'discount_statistics#index'

    resources :posts do
      resources :gallery_images, :except => [:index, :show] do
        delete 'destroy_file', :on => :member, :as => :destroy_file
      end
    end

    resources :invitations, :only => :index

    get 'organizations/rated' => 'organizations#index', :defaults => { :rated => true }

    resources :organizations do
      Organization.available_suborganization_kinds.each do |kind|
        resource kind, :except => [:index] do
          resources :services, :except => [:index, :show]
        end
      end

      resource :meal do
        resources :menus, :except => [:index, :show]
      end

      resource :billiard, :only => [] do
        resources :pool_tables, :except => [:index, :show]
      end

      resource :sauna, :except => [] do
        resources :sauna_halls, :except => :index
      end

      resources :sauna_halls, :only => [] do
        resources :gallery_images, :only => [:new, :create, :destroy, :edit, :update] do
          delete 'destroy_file', :on => :member, :as => :destroy_file
        end
      end

      resources :gallery_files,  :only => [:new, :create, :destroy, :edit, :update] do
        delete 'destroy_file', :on => :member, :as => :destroy_file
      end

      resources :gallery_images, :only => [:new, :create, :destroy, :edit, :update] do
        delete 'destroy_file', :on => :member, :as => :destroy_file
      end

      resources :organizations,  :only => [:new, :create, :destroy]
    end

    Organization.available_suborganization_kinds.each do |kind|
      resources kind.pluralize, :only => :index do
        resources :gallery_images, :only => [:new, :create, :destroy, :edit, :update]
      end
    end

    resources :tickets, only: [:index, :edit, :update, :destroy] do
      get ':by_state' => 'tickets#index', :on => :collection, :as => :with_state
    end

    resources :offers, :only => [:index, :edit, :update, :destroy] do
      put 'fire_event_state/:event' => 'offers#fire_state_event', :on => :member, :as => :fire_state_event
    end

    namespace :admin do
      resources :users
      post "users/mass_update" => 'users#mass_update', :as => 'user/mass_update'
    end

    resources :webcams do
      get 'snapshot' => 'afishas#snapshot', :on => :member, :as => :snapshot
      put 'snapshot' => 'afishas#snapshot', :on => :member, :as => :snapshot
    end

    root :to => 'organizations#index'
  end
end
