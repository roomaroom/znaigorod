class Photogallery < ActiveRecord::Base
  attr_accessible :agreement, :description, :og_description, :og_image_content_type, :og_image_file_name, :og_image_file_size, :og_image_updated_at, :og_image_url, :slug, :title, :vfs_path
end
