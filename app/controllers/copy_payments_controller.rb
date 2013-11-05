class CopyPaymentsController < ApplicationController
  inherit_resources

  actions :new, :create

  belongs_to :certificate, :optional => true
  belongs_to :coupon,      :optional => true
  belongs_to :discount,    :optional => true
  belongs_to :ticket,      :optional => true

  def create
    create! do |success, failure|
      success.html { redirect_to redirect_path and return }
    end
  end

  protected

  def build_resource
    super
    @copy_payment.user = current_user if current_user

    @copy_payment
  end

  def redirect_path
    return discount_path(parent) if parent.free? && parent.is_a?(Discount)

    @copy_payment.service_url
  end
end
