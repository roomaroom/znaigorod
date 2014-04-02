class My::BetPaymentsController < My::ApplicationController
  actions :new, :create

  belongs_to :afisha, :bet

  defaults :singleton => true

  layout false

  skip_authorization_check

  def create
    create! { |success, failure|
      success.html { redirect_to @bet_payment.service_url and return }
      failure.html { render :new and return }
    }
  end

  protected

  def build_resource
    super
    @bet_payment.user = current_user

    @bet_payment
  end
end
