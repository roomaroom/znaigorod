class My::GalleryImagesController < My::ApplicationController
  load_and_authorize_resource
  actions :create, :destroy, :index, :new
  custom_actions :collection => :destroy_all

  belongs_to :afisha, :polymorphic => true, :optional => true

  def index
    index!{
      @images = current_user.account.gallery_images
    }
  end

  def new
    new!{
      @account = current_user.account
    }

  end

  def create
    if params[:afisha_id].present?
      @afisha = current_user.afisha.available_for_edit.find(params[:afisha_id])
      @gallery_image = @afisha.gallery_images.create(:file => params[:gallery_images][:file])
    else
      @gallery_image = current_user.account.gallery_images.create(:file => params[:gallery_images][:file])
    end
  end

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end

  def destroy_all
    destroy_all! {
      if params[:afisha_id].present?
        @afisha = current_user.afisha.available_for_edit.find(params[:afisha_id])
        @afisha.gallery_images.destroy_all
        redirect_to edit_step_my_afisha_path(@afisha.id, :step => :fourth) and return
      else
        current_user.account.gallery_images.destroy_all
        redirect_to new_my_gallery_images_path()
      end
    }
  end
end
