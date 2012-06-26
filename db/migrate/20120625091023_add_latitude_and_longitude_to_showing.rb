class AddLatitudeAndLongitudeToShowing < ActiveRecord::Migration
  def change
    add_column :showings, :latitude, :string
    add_column :showings, :longitude, :string
  end
end
