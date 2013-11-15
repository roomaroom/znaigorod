class AddFileImageUrlToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :file_image_url, :string
  end
end
