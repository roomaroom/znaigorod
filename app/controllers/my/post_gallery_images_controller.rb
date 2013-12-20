class My::PostGalleryImagesController < My::ApplicationController
  defaults :resource_class => GalleryImage, :collection_name => :gallery_images, :instance_name => :gallery_image

  belongs_to :post, :polymorphic => true, :optional => true
end
