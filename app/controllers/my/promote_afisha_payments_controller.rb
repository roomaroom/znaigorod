class My::PromoteAfishaPaymentsController < My::ApplicationController
  actions :new, :create

  belongs_to :afisha

  skip_authorization_check

  def create
    create! { |success, failure|
      success.html do
        integration_module = ActiveMerchant::Billing::Integrations::Robokassa
        integration_helper = integration_module::Helper.new(@promote_afisha_payment.id, Settings['robokassa.login'], secret: Settings['robokassa.secret_1'], amount: @promote_afisha_payment.amount)

        redirect_to "#{integration_module.service_url}?#{integration_helper.form_fields.to_query}" and return
      end

      failure.html { render :new and return }
    }
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
