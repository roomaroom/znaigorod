Znaigorod::Application.routes.draw do
  namespace :my do
    resources :reviews, :only => [:new, :create] do
      get 'add' => 'reviews#add', :on => :collection

      Review.descendant_names_without_prefix.each do |name|
        get 'new/:type' => 'reviews#new',
          :on => :collection,
          :as => "new_#{name}",
          :defaults => { :type => name },
          :constraints => { :type => name }
      end
    end
  end
end
