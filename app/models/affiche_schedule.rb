class AfficheSchedule < ActiveRecord::Base
  belongs_to :affiche

  attr_accessible :affiche, :ends_at, :ends_on, :hall, :holidays, :place, :starts_at, :starts_on

  validates_presence_of :ends_at, :ends_on, :place, :starts_at, :starts_on

  after_save :create_showings

  private
    def create_showings
      (starts_on..ends_on).each do |day|
        affiche.create_showing(:place => place, :hall => hall, :starts_at => starts_at_for(day), :ends_at => ends_at_for(day))
      end
    end

    def starts_at_for(day)
      "#{day.to_s} #{I18n.l(starts_at, :format => '%H:%M')}".to_datetime
    end

    def ends_at_for(day)
      "#{day.to_s} #{I18n.l(ends_at, :format => '%H:%M')}".to_datetime
    end
end

# == Schema Information
#
# Table name: affiche_schedules
#
#  id         :integer         not null, primary key
#  affiche_id :integer
#  starts_on  :date
#  ends_on    :date
#  starts_at  :time
#  ends_at    :time
#  holidays   :string(255)
#  place      :string(255)
#  hall       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

