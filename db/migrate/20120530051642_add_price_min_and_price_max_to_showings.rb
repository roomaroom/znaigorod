class AddPriceMinAndPriceMaxToShowings < ActiveRecord::Migration
  def change
    rename_column :showings, :price, :price_min
    add_column :showings, :price_max, :integer
  end
end
