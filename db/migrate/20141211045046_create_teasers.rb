class CreateTeasers < ActiveRecord::Migration
  def change
    create_table :teasers do |t|
      t.integer :items_quantity
      t.integer :image_width
      t.integer :image_height
      t.string :background_color
      t.string :border_color
      t.string :text_color
      t.string :link_color
      t.string :title
      t.string :slug
      t.timestamps
    end
  end
end
