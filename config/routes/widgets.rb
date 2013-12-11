Znaigorod::Application.routes.draw do
  namespace :widgets  do
    resources :webcams, :only => :new do
      get 'show'   => 'webcams#show',   :on => :collection
      get 'yandex' => 'webcams#yandex', :on => :collection
    end

    root :to => 'widgets#index'
  end
end
