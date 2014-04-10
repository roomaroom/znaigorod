class CommentsImagesController < ApplicationController
  def create
    @comments_image = current_user.comments_images.create :file => params[:comments_image]

    render :json => {
      :files => [
        {
          :id           => @comments_image.id,
          :name         => @comments_image.file_file_name,
          :width        => 100,
          :height       => 100,
          :url          => view_context.resized_image_url(@comments_image.file_url, 1920, 1080),
          :thumbnailUrl => view_context.resized_image_url(@comments_image.file_url, 100, 100),
          :deleteUrl    => "/comments_images/#{@comments_image.id}",
        }
      ]
    }
  end

  def destroy
    @comments_image = current_user.comments_images.find(params[:id])
    @comments_image.destroy

    render :nothing => true
  end
end
