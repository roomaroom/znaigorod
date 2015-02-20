class AddDescriptionToTeasers < ActiveRecord::Migration
  def change
    add_column :teaser_items, :description, :text
    remove_columns :teasers, :image_width, :image_height, :background_color, :text_color, :link_color
    rename_column :teaser_items, :text, :link_text
  end
end
