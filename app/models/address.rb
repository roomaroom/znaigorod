class Address < ActiveRecord::Base
  belongs_to :organization

  def to_s
    "#{street}, #{house}" if street && house
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id              :integer         not null, primary key
#  street          :string(255)
#  house           :string(255)
#  organization_id :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  latitude        :string(255)
#  longitude       :string(255)
#

