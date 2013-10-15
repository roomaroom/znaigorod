class ReindexSuborganizations < ActiveRecord::Migration
  def change
    [Billiard, CarWash, Meal, SalonCenter, Sauna].each { |model| model.reindex }
  end
end
