class AddWareToSaunaAccessories < ActiveRecord::Migration
  def change
    add_column :sauna_accessories, :ware, :boolean
  end
end
