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

# == Schema Information
#
# Table name: payments
#
#  id               :integer          not null, primary key
#  paymentable_id   :integer
#  number           :integer
#  phone            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  paymentable_type :string(255)
#  type             :string(255)
#  amount           :float
#  details          :text
#  state            :string(255)
#  email            :string(255)
#

