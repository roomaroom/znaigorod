class Showing < ActiveRecord::Base
  attr_accessible :ends_at, :hall, :place, :price_max, :price_min, :starts_at

  belongs_to :affiche

  validates_presence_of :place, :price_max, :price_min, :starts_at

  default_scope order(:starts_at)

  delegate :tags, :title, :to => :affiche, :prefix => true

  after_create  :index_affiche
  after_destroy :index_affiche

  default_value_for :price_max, 0
  default_value_for :price_min, 0

  searchable do
    date :starts_on
    integer :price_max
    integer :price_min
    integer(:ends_at_hour) { ends_at.try(:hour) }
    integer(:starts_at_hour) { starts_at.hour }
    string(:affiche_category) { I18n.transliterate(affiche.class.model_name.human).downcase.gsub(/[^[:alnum:]]+/, '_') }
    string(:tags, :multiple => true) { affiche_tags }
    time :ends_at
    time :starts_at
  end

  def starts_on
    starts_at.to_date
  end

  def self.tags
    search_params = { :starts_on_gt => Date.today, :starts_on_lt => Date.today + 4.weeks }

    ShowingSearch.new(search_params).tags_facet.rows.map(&:value)
  end

  # NOTE: ShowingSearch.new(...).results does not apply default scope
  def self.nearest
    where(:id => ShowingSearch.new(:starts_at_gt => DateTime.now, :starts_at_lt => DateTime.now.end_of_day).result_ids).limit(5)
  end

  private
    def index_affiche
      affiche.index
    end
end

# == Schema Information
#
# Table name: showings
#
#  id              :integer         not null, primary key
#  affiche_id      :integer
#  place           :string(255)
#  starts_at       :datetime
#  price_min       :integer
#  hall            :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  ends_at         :datetime
#  price_max       :integer
#  organization_id :integer
#

