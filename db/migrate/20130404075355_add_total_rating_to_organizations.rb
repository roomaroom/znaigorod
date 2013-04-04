class AddTotalRatingToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :total_rating, :float
  end
end
