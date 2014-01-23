class AddImageToWork < ActiveRecord::Migration
  def change
    add_column :works, :image_file_name,    :string
    add_column :works, :image_content_type, :string
    add_column :works, :image_file_size,    :integer
  end
end
