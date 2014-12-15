class CreateTeaserItems < ActiveRecord::Migration
  def change
    create_table :teaser_items do |t|
      t.belongs_to :teaser
      t.string :image_content_type
      t.string :image_file_name
      t.string :image_file_size
      t.string :image_url
      t.string :url
      t.text :text
      t.timestamps
    end
  end
end
