class Price < ActiveRecord::Base
  extend Enumerize

  attr_accessible :kind, :value, :count, :period

  belongs_to :service

  enumerize :kind, in: [:single, :multiple], predicates: true

  validates_presence_of :kind, :value
  validates_presence_of :count, :period, :if => :multiple?
end

# == Schema Information
#
# Table name: prices
#
#  id         :integer          not null, primary key
#  kind       :string(255)
#  value      :integer
#  count      :integer
#  period     :string(255)
#  service_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

