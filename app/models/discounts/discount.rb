# encoding: utf-8

class Discount < ActiveRecord::Base
  attr_accessible :title, :description, :ends_at, :kind, :starts_at,
                  :discount, :organization_id

  belongs_to :account
  belongs_to :organization

  validates_presence_of :title, :description, :kind, :starts_at, :ends_at

  extend Enumerize
  serialize :kind, Array
  enumerize :kind, :in => [:beauty, :entertainment, :sport], :multiple => true, :predicates => true

  extend FriendlyId
  friendly_id :title, use: :slugged
end

# == Schema Information
#
# Table name: discounts
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  description               :text
#  poster_url                :text
#  type                      :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  poster_image_url          :text
#  starts_at                 :datetime
#  ends_at                   :datetime
#  slug                      :string(255)
#  total_rating              :float
#  kind                      :text
#  number                    :integer
#  origin_price              :integer
#  price                     :integer
#  discounted_price          :integer
#  discount                  :integer
#  payment_system            :string(255)
#  state                     :string(255)
#  organization_id           :integer
#  account_id                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

