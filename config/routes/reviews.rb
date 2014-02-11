Znaigorod::Application.routes.draw do
  namespace :my do
    resources :reviews, :except => :index do
      get 'add' => 'reviews#add', :on => :collection

      post :preview,       :on => :collection

      Review.descendant_names_without_prefix.each do |name|
        get 'new/:type' => 'reviews#new',
          :on => :collection,
          :as => "new_#{name}",
          :defaults => { :type => name },
          :constraints => { :type => name }
      end

      resources :gallery_images, :except => [:show, :edit, :update]
    end

    #TODO нужно для ссылки удаления фото в /my/rewiews/:id
    Review.descendant_names.each do |name|
      resources "#{name}", :only => :show do
        resources :gallery_images, :except => [:show, :edit, :update]
      end
    end
  end

  resources :reviews, :only => [:index, :show] do
  end
end
