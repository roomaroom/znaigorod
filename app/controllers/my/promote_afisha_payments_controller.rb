class My::PromoteAfishaPaymentsController < My::ApplicationController
  actions :create

  belongs_to :afisha

  skip_authorization_check

  def create
    create! do |success, failure|
      success.html { redirect_to @promote_afisha_payment.service_url and return }
    end
  end

  protected

  def resource_instance_name
    :promote_afisha_payment
  end

  def build_resource
    super
    @promote_afisha_payment.user = current_user

    @promote_afisha_payment
  end
end
