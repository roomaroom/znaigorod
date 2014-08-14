class AddRatingFieldToWork < ActiveRecord::Migration
  def change
    add_column :works, :rating, :float
  end
end
