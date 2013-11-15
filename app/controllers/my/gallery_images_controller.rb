class My::GalleryImagesController < My::ApplicationController
  load_and_authorize_resource
  actions :create, :destroy, :index, :new, :edit, :update
  custom_actions :collection => :destroy_all

  belongs_to :afisha, :polymorphic => true, :optional => true

  def index
    index!{
      @images = Kaminari.paginate_array(current_user.account.gallery_images).page(params[:page]).per(15)
      render :partial => 'account_gallery_images' and return if request.xhr?
    }
  end

  def new
    new!{
      @account = current_user.account
    }
  end

  def edit
    edit!{
      @gallery_image = GalleryImage.find(params[:id])
    }

  end

  def update
    @gallery_image = GalleryImage.find(params[:id])
    @gallery_image.attributes = params[:gallery_image]

    account = current_user.account
    account.avatar_url = @gallery_image.file_image_url

    if @gallery_image.save && account.save
      redirect_to my_gallery_images_path()
    else
      render :edit
    end
  end

  def create
    if params[:afisha_id].present?
      @afisha = current_user.afisha.available_for_edit.find(params[:afisha_id])
      @gallery_image = @afisha.gallery_images.create(:file => params[:gallery_images][:file])
    else
      @gallery_image = current_user.account.gallery_images.create(:file => params[:gallery_images][:file])
      img = current_user.account.gallery_images.last
      img.file_image_url = img.file_url
      img.save!
    end
  end

  def destroy
    img = GalleryImage.find(params[:id])
    account = current_user.account
    if account.avatar_url == img.file_image_url
      account.avatar_url = account.resolve_default_avatar_url
      account.save!
    end

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
        account = current_user.account
        account.gallery_images.destroy_all
        account.avatar_url = account.resolve_default_avatar_url
        redirect_to new_my_gallery_images_path()
      end
    }
  end
end
