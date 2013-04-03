Znaigorod::Application.routes.draw do
  get 'crm/organizations' => 'crm/organizations#index', as: :manage_sales

  namespace :crm do
    resources :organizations, only: [:index, :show, :edit, :update] do
      resources :activities
      resources :contacts, except: :show
    end

    resources :activities, only: :index

    root to: 'organizations#index'
  end
end

