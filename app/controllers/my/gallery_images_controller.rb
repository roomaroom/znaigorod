class My::GalleryImagesController < My::ApplicationController
  load_and_authorize_resource

  actions :index, :new, :create, :destroy
  custom_actions :collection => :destroy_all

  belongs_to :account, :optional => true
  belongs_to :afisha,  :optional => true
  belongs_to :post,    :optional => true

  respond_to :html, :js, :json

  def destroy
    destroy! { render :nothing => true and return }
  end

  def destroy_all
    destroy_all! do
      parent.gallery_images.destroy_all

      redirect_to parent_path and return
    end
  end

  protected

  # защита от подмены accound_id на форме
  def association_chain
    super

    @association_chain = [current_user.account] if params[:account_id]

    @association_chain
  end

  def build_resource_params
    [:file => params.try(:[], :gallery_images).try(:[], :file)]
  end
end
