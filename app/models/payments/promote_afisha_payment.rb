class PromoteAfishaPayment < Payment
  def approve!
    super

    promote_afisha
    create_notification_message
  end

  default_value_for :amount, Settings['promote_afisha.price'] || 50.0

  private

  def payment_system
    :robokassa
  end

  alias :afisha :paymentable

  def promote_afisha
    afisha.update_attributes! :promoted_at => Time.zone.now
  end

  def create_notification_message
    if user
      NotificationMessage.delay(:queue => 'critical').create(:account => user.account, :kind => :afisha_promoted, :messageable => afisha)
    end
  end
end
