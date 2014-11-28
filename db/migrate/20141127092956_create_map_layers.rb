class CreateMapLayers < ActiveRecord::Migration
  def change
    create_table :map_layers do |t|
      t.string :title
      t.belongs_to :map_project
      t.timestamps
    end
  end
end
