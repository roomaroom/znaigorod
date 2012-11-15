class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.text :category
      t.text :feature
      t.text :age
      t.text :tag
      t.string :context_type
      t.integer :context_id

      t.timestamps
    end
  end
end
