class Webanketa < ActiveRecord::Base
  attr_accessible :expires_at, :text

  belongs_to :context, :polymorphic => true

  scope :actual, -> { where 'expires_at > ?', Time.zone.now }

  validates :text,       :presence => true
  validates :expires_at, :presence => true
end

# == Schema Information
#
# Table name: webanketas
#
#  id           :integer          not null, primary key
#  text         :text
#  expires_at   :datetime
#  context_id   :integer
#  context_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

