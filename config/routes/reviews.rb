Znaigorod::Application.routes.draw do
  namespace :my do
    resources :reviews, :except => :index do
      get 'add'         => 'reviews#add',         :on => :collection
      get 'images/add'  => 'reviews#add_images',  :on => :member
      get 'poster/edit' => 'reviews#edit_poster', :on => :member

      post :preview, :on => :collection

      put 'publish' => 'reviews#send_to_published', :on => :member
      put 'draft'   => 'reviews#send_to_draft',     :on => :member

      Review.descendant_names_without_prefix.each do |name|
        get 'new/:type' => 'reviews#new',
          :on => :collection,
          :as => "new_#{name}",
          :defaults => { :type => name },
          :constraints => { :type => name }
      end

      resources :gallery_images, :only => [:new, :create, :destroy]
    end

    # TODO: Used at app/views/my/gallery_images/_gallery_image.html.erb:5
    Review.descendant_names.each do |name|
      resources name, :only => :show do
        resources :gallery_images, :only => :destroy
      end
    end
  end

  resources :reviews, :only => [:index, :show] do
  end
end
