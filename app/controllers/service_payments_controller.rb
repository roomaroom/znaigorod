class ServicePaymentsController < ApplicationController
  inherit_resources

  actions :new, :create

  def create
    create! do |success, failure|
      success.html { redirect_to @service_payment.service_url and return }
    end
  end
end
