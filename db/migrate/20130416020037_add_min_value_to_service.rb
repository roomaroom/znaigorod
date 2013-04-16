class AddMinValueToService < ActiveRecord::Migration
  def change
    add_column :services, :min_value, :integer
  end
end
