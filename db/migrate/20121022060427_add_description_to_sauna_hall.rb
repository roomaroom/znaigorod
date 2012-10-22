class AddDescriptionToSaunaHall < ActiveRecord::Migration
  def change
    add_column :sauna_halls, :description, :text
  end
end
