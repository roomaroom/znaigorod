class CreateSectionPages < ActiveRecord::Migration
  def change
    create_table :section_pages do |t|
      t.string :title
      t.text :content
      t.text :cached_content_for_index
      t.text :cached_content_for_show
      t.belongs_to :section
      t.string :poster_image_url
      t.string :poster_image_file_name
      t.string :poster_image_content_type
      t.string :poster_image_file_size
      t.timestamps
    end
  end
end
