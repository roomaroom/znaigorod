class RbkmoneyController < ApplicationController
  include ActiveMerchant::Billing::Integrations

  skip_before_filter :verify_authenticity_token

  def success
    #notification = Rbkmoney::Notification.new(request.raw_post, :secret => 'SECRET')
    notification = Rbkmoney::Notification.new(request.raw_post)

    if notification.acknowledge
      if notification.complete?
        payment = Payment.find(notification.item_id)
        payment.approve!
      end

      render :nothing => true
    else
      head :bad_request
    end
  end

  def fail
  end
end
