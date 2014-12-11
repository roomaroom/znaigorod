class CreateTeaserItems < ActiveRecord::Migration
  def change
    create_table :teaser_items do |t|
      t.text :text
      t.belongs_to :teaser
      t.string :image_url
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.timestamps
    end
  end
end
