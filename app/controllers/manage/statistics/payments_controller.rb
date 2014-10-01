class Manage::Statistics::PaymentsController < Manage::ApplicationController
  load_and_authorize_resource
  helper_method :order_by

  has_scope :page, :default => 1

  def index
    @payments = Payment.order('id desc').page(params[:page]).per(20).send(order_by)
  end

  protected

  def order_by
    params[:order_by] || 'every'
  end
end
