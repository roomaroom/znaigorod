# encoding: utf-8

Znaigorod::Application.routes.draw do
  #get '/znakomstva' => 'accounts#index', :as => :znakomstva
  #get '/accounts', :to => redirect('/znakomstva')

  Inviteables.instance.transliterated_category_titles.each do |hash|
    get "accounts/#{hash.transliterated}" => 'accounts#index',
      :constraints => { :category => hash.transliterated },
      :defaults => { :category => hash.transliterated },
      :as => "accounts_#{hash.transliterated}"
  end

  resources :accounts, :only => [:index, :show] do
    put 'change_friendship' => 'friends#change_friendship', :as => :change_friendship

    resources :events, :only => :index
    resources :comments, :only => :index
    resources :friends, :only => :index
    resources :votes, :only => :index
    resources :visits, :only => :index
    resources :feeds, :only => :index
  end
end
