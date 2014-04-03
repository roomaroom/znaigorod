class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :context_id
      t.string :context_type
      t.string :title
      t.integer :capacity
      t.integer :rooms_count
      t.text :description
      t.text :feature

      t.timestamps
    end
  end
end
