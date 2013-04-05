class AddTotalRatingToAffiches < ActiveRecord::Migration
  def change
    add_column :affiches, :total_rating, :float
  end
end
