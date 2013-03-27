class AddOfferToCarWashes < ActiveRecord::Migration
  def change
    add_column :car_washes, :offer, :text
  end
end
