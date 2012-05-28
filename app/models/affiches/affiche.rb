class Affiche < ActiveRecord::Base
  attr_accessible :description, :poster_url, :image_url, :showings_attributes, :tag, :title, :vfs_path

  validates_presence_of :description, :poster_url, :title

  has_many :showings, :dependent => :destroy

  accepts_nested_attributes_for :showings, :allow_destroy => true

  default_scope order('affiches.id DESC')

  scope :with_showings, -> { includes(:showings).where('showings.starts_at > ?', Date.today) }

  scope :with_images, -> { where('image_url IS NOT NULL') }

  scope :latest, ->(count) { limit(count) }

  def showings_grouped_by_day(search_params = nil)
    search_params ||= { :starts_on_gt => Date.today, :starts_on_lt => Date.today + 4.weeks }
    showing_ids = ShowingSearch.new(search_params).result_ids

    showings.where(:id => showing_ids).where('starts_at > ?', Date.today).group_by(&:starts_on)
  end

  def tags
    tag.split(/,\s+/).map(&:squish)
  end
end

# == Schema Information
#
# Table name: affiches
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  description    :text
#  original_title :string(255)
#  poster_url     :string(255)
#  trailer_code   :text
#  type           :string(255)
#  tag            :text
#  vfs_path       :string(255)
#  image_url      :string(255)
#

