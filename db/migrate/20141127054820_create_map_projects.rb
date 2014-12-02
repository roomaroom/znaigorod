class CreateMapProjects < ActiveRecord::Migration
  def change
    create_table :map_projects do |t|
      t.string :title
      t.string :slug

      t.timestamps
    end
  end
end
