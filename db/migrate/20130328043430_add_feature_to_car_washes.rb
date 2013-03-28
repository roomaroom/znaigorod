class AddFeatureToCarWashes < ActiveRecord::Migration
  def change
    add_column :car_washes, :feature, :text
  end
end
