# encoding: utf-8

require 'payments/payment'

class CopyPayment < Payment
  attr_accessible :number, :phone, :email

  has_one :sms, :as => :smsable

  has_many :copies, after_add: :reserve_copy

  validates :email,  :presence => true, :if => :payment_system_rbkmoney?
  validates :number, :presence => true, :numericality => { :greater_than => 0 }, :unless => :copies_with_seats?
  validates :phone,  :presence => true, :format => { :with => /\A\+7-\(\d{3}\)-\d{3}-\d{4}\z/ }

  delegate :payment_system_rbkmoney?, :to => :paymentable
  delegate :free?,                    :to => :paymentable, :prefix => true

  before_validation :check_copies_number

  before_create :set_amount

  after_create :reserve_copies
  after_create :create_member, :if => [:user_id?, :paymentable_is_discount?]
  after_create :create_visit,  :if => [:user_id?, :paymentable_is_ticket?]
  after_create :approve!, :if => :paymentable_free?

  attr_accessor :copy_for_sale_ids, :copies_with_seats
  attr_accessible :copy_for_sale_ids, :copies_with_seats
  def copy_for_sale_ids
    (@copy_for_sale_ids ||= []).delete_if(&:blank?).map(&:to_i)
  end

  def copies_with_seats?
    copies_with_seats.present?
  end

  def approve!
    super
    copies.map(&:sell!)
    create_sms! :phone => phone, :message => message
    send_emails if paymentable.emails.any?
  end

  def cancel_and_release_tickets!
    cancel!
    copies.map(&:release!)
  end

  private

  def check_copies_number
    errors[:base] << I18n.t('activerecord.errors.messages.not_enough_tickets') if number? && paymentable.copies_for_sale.count < number
  end

  def set_amount
    self.amount = paymentable.price * (number || copy_for_sale_ids.count)
  end

  def reserve_copies
    if number
      copies << paymentable.copies_for_sale.limit(number)
    else
      copy_for_sale_ids.each do |copy_id|
        copies << paymentable.copies_for_sale.find(copy_id)
      end
    end
  end

  def reserve_copy(copy)
    copy.reserve!
  end

  def message
    "#{paymentable.message_for_sms}. " << (copies.many? ? 'Коды: ' : 'Код: ') << copies.join('; ')
  end

  def send_emails
    paymentable.emails.each do |email|
      CopyPaymentMailer.delay(:queue => 'mailer').notification(email, self)
    end
  end

  def paymentable_is_ticket?
    paymentable.is_a? Ticket
  end

  def paymentable_is_discount?
    paymentable.is_a? Discount
  end

  def create_visit
    paymentable.afisha.visits.create! :user_id => user_id
  end

  def create_member
    member = paymentable.members.new { |member| member.account = user.account }
    member.save

    true
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

