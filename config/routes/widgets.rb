Znaigorod::Application.routes.draw do
  namespace :widgets  do
    resources :webcams, :only => [:new] do
      get 'yandex' => 'webcams#yandex', :on => :collection
      get 'show' => 'webcams#show', :on => :collection
    end
    get '/' => 'application#list'
  end
end
