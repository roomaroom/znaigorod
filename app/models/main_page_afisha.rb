class MainPagePoster < ActiveRecord::Base
  attr_accessible :afisha_id, :expires_at, :position

  belongs_to :afisha

  scope :ordered, -> { order :position }
  scope :actual, -> { where 'expires_at > ?', Time.zone.now }

  validates :expires_at, :presence => true

  def self.latest_afishas
    search = Afisha.search do
      order_by :created_at, :desc
      paginate :page => 1, :per_page => 3
      with :state, :published
    end

    search.results
  end
end

# == Schema Information
#
# Table name: main_page_afisha
#
#  id         :integer          not null, primary key
#  afisha_id  :integer
#  position   :integer
#  expires_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

