Znaigorod::Application.routes.draw do
  namespace :widgets  do
    resources :webcams, :only => [:new, :create] do
      get 'yandex' => 'webcams#yandex', :on => :collection
    end
    get '/' => 'application#list'
  end
end
