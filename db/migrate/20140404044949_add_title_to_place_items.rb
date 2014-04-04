class AddTitleToPlaceItems < ActiveRecord::Migration
  def change
    add_column :place_items, :title, :string
  end
end
