class Manage::Statistics::SmsClaimsController < Manage::ApplicationController
  has_scope :page, :default => 1

  authorize_resource

  def index
    @sms_claims = SmsClaim.ordered.page(params[:page]).per(20)
  end
end
