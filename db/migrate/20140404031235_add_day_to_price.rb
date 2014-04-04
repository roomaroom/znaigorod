class AddDayToPrice < ActiveRecord::Migration
  def change
    add_column :prices, :day_kind, :string
  end
end
