class WorksController < ApplicationController
  inherit_resources
  belongs_to :contest, :polymorphic => true, :optional => true
  belongs_to :photogallery, :polymorphic => true, :optional => true

  load_and_authorize_resource :only => [:new, :create]

  actions :new, :create, :show

  def create
    create! { @work.context }
  end

  def show
    show! {
      @work.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
      if @work.context.is_a?(Photogallery)
        @photogalleries = Photogallery.find(:all, :conditions => ["slug != ?", params[:photogallery_id]], :limit => 5)
        @more_photos = Photogallery.find(params[:photogallery_id])
      end
    }
  end

  def destroy
    Work.find(params[:id]).destroy
    render :nothing => true
  end

  def add
    @photogallery = Photogallery.find(params[:photogallery_id])

    if request.xhr?
      @work_image = @photogallery.works.create! :image => params[:work_upload], :agree => '1'
      render :json =>  {
        :files => [
          {
            :id           => @work_image.id,
            :name         => @work_image.image_file_name,
            :width        => 130,
            :height       => 100,
            :url          => view_context.resized_image_url(@work_image.image_url, 1920, 1080),
            :thumbnailUrl => view_context.resized_image_url(@work_image.image_url, 130, 100),
            :deleteUrl    => "/photogalleries/#{params[:photogallery_id]}/works/#{@work_image.id}",
          }
        ]
      }
    end
  end

  protected

  def build_resource
    @work = super.tap { |w| w.account_id = current_user.account_id }
  end
end
