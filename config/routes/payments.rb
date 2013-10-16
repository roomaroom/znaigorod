Znaigorod::Application.routes.draw do
  resources :tickets, :only => [] do
    resources :copy_payments, :only => [:new, :create]
  end

  [Certificate, Coupon, Discount].each do |klass|
    resources klass.name.underscore.pluralize, :only => [] do
      resources :copy_payments, :only => [:new, :create]
    end
  end

  scope 'robokassa' do
    post 'paid'    => 'robokassa#paid'
    post 'success' => 'robokassa#success'
    post 'fail'    => 'robokassa#fail'
  end

  scope 'rbkmoney' do
    post 'success' => 'rbkmoney#success'
  end
end
