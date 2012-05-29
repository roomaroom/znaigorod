class Showing < ActiveRecord::Base
  attr_accessible :ends_at, :hall, :place, :price, :starts_at

  belongs_to :affiche

  validates_presence_of :place, :price, :starts_at

  default_scope order(:starts_at)

  delegate :tags, :title, :to => :affiche, :prefix => true

  searchable do
    date                                      :starts_on
    integer(:ends_at_hour)                    { ends_at.try(:hour) }
    integer                                   :price
    integer(:starts_at_hour)                  { starts_at.hour }
    string(:categories, :multiple => true)    { [affiche.class.name.underscore] }
    string(:tags, :multiple => true)          { affiche_tags }
    text                                      :affiche_title
    time                                      :starts_at
  end

  def starts_on
    starts_at.to_date
  end

  def self.tags
    search { facet :tags }.facets.flat_map(&:rows).map(&:value)
  end

  # NOTE: ShowingSearch.new(...).results does not apply default scope
  def self.nearest
    where(:id => ShowingSearch.new(:starts_at_gt => DateTime.now, :starts_at_lt => DateTime.now.end_of_day).result_ids).limit(5)
  end
end

# == Schema Information
#
# Table name: showings
#
#  id         :integer         not null, primary key
#  affiche_id :integer
#  place      :string(255)
#  starts_at  :datetime
#  price      :integer
#  hall       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  ends_at    :datetime
#

