class Advert < ActiveRecord::Base
  extend Enumerize
    attr_accessible :title, :description, :price, :kind, :categories, :phone

  belongs_to :account

  has_many   :gallery_images,        :as => :attachable,     :dependent => :destroy

  validates_presence_of :title, :description, :kind, :categories, :phone
  enumerize :kind,
    in: [:buy, :sell, :exchange, :more]

  enumerize :categories,
    in: [:cat1, :cat2]
end

# == Schema Information
#
# Table name: adverts
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  price       :float
#  kind        :text
#  categories  :text
#  phone       :string(255)
#  account_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

