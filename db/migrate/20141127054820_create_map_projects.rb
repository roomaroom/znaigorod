class CreateMapProjects < ActiveRecord::Migration
  def change
    create_table :map_projects do |t|
      t.string :title

      t.timestamps
    end
  end
end
