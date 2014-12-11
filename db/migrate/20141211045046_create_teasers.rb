class CreateTeasers < ActiveRecord::Migration
  def change
    create_table :teasers do |t|
      t.integer :items_quantity
      t.integer :image_width
      t.integer :image_height
      t.integer :text_length
      t.string :title
      t.timestamps
    end
  end
end
