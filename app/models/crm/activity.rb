# encoding: utf-8

class Activity < ActiveRecord::Base
  attr_accessible :title, :state, :activity_at, :user_id, :contact_id, :status, :kind

  belongs_to :organization
  belongs_to :manager, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :contact
  validates_presence_of :title, :state, :status, :activity_at, :manager, :kind
  after_save :set_organization_status, if: :state_completed?
  after_save :handle_debtors,  if: :state_completed?
  default_scope order('activity_at desc')

  searchable do
    date(:activity_on) { activity_at.try :to_date }
    integer :user_id
    string  :kind
    string  :state
    string  :status
    time    :activity_at
  end

  extend Enumerize
  enumerize :status, in: [:fresh, :talks, :waiting_for_payment, :client, :client_economy, :client_standart, :client_premium, :non_cooperation, :debtor, :advertising_service],
            default: :fresh, predicates: { prefix: true }
  enumerize :state, in: [:planned, :completed], default: :planned, predicates: { prefix: true }
  enumerize :kind, in: [:phone, :email, :repeated_phone, :meeting, :meeting_contract, :meeting_payment]

  scope :with_state, ->(state) {where(state: state)}
  scope :with_meeting, -> {where(kind: [:meeting, :meeting_payment, :meeting_contract])}

  def activity_date
    activity_at.to_date
  end

  def client?
    status_client? || status_client_economy? || status_client_standart? || status_client_premium?
  end

  def handle_debtors
    if !client?
      (organization.sauna.try(:sauna_hall_ids) || []).each do |id|
        Sunspot.remove_by_id SaunaHall, id
      end

      (organization.hotel.try(:room_ids) || []).each do |id|
        Sunspot.remove_by_id Room, id
      end
    else
      (organization.sauna.try(:sauna_halls) || []).each do |record|
        record.index!
      end

      (organization.hotel.try(:rooms) || []).each do |record|
        record.index!
      end
    end

    organization.index!
    organization.index_suborganizations
  end

  private

  def set_organization_status
    organization.status = status
    organization.save
  end
end

# == Schema Information
#
# Table name: activities
#
#  id              :integer          not null, primary key
#  title           :text
#  organization_id :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :string(255)
#  state           :string(255)
#  activity_at     :datetime
#  contact_id      :integer
#  kind            :string(255)
#

