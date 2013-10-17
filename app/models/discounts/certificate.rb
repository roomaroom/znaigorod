# encoding: utf-8

class Certificate < Discount
  include Copies

  attr_accessible :origin_price, :price, :payment_system, :number, :origin_url

  validates :origin_url, :format => URI::regexp(%w(http https)), :if => :origin_url?
  validates_presence_of :origin_price, :price, :payment_system, :number

  before_validation :set_discount

  enumerize :payment_system, :in => [:robokassa, :rbkmoney]

  private

  def set_discount
    self.discount = ((1 - price.to_f / origin_price.to_f) * 100).round
  end
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
#  origin_url                :text
#  organization_id           :integer
#  account_id                :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  constant                  :boolean
#

