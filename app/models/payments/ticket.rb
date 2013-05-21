class Ticket < ActiveRecord::Base
  include Copies

  attr_accessible :number, :original_price, :price, :description, :stale_at

  belongs_to :affiche

  validates_presence_of :number, :original_price, :price, :description, :stale_at

  def organization
    affiche(:include => { :showings => :organizatiob }).showings.first.organization
  end

  delegate :title, :to => :affiche, :prefix => true
  delegate :title, :to => :organization, :prefix => true, :allow_nil => true

  searchable do
    text :affiche_title
    text :organization_title
  end

  def discount
    ((original_price - price) * 100 / original_price).round
  end
end

# == Schema Information
#
# Table name: tickets
#
#  id             :integer          not null, primary key
#  affiche_id     :integer
#  number         :integer
#  original_price :float
#  price          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :text
#  stale_at       :datetime
#

