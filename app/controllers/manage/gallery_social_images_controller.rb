class Manage::GallerySocialImagesController < Manage::ApplicationController
  load_and_authorize_resource

  actions :new, :create, :destroy, :update, :edit
  custom_actions :collection => :destroy_all

  belongs_to :afisha,         :optional => true
  belongs_to :review,         :optional => true
  belongs_to :review_article, :optional => true
  belongs_to :review_photo,   :optional => true
  belongs_to :review_video,   :optional => true

  def create
    create! { collection_path }
  end

  def update
    update! { collection_path }
  end

  def destroy
    destroy! {
      render :nothing => true and return
    }
  end

  def destroy_all
    destroy_all! {
      parent.gallery_social_images.destroy_all
      parent.update_attributes :vk_aid => nil, :yandex_fotki_url => nil
      redirect_to collection_path and return
    }
  end

  protected
    def collection_path
      manage_afisha_show_path(parent) if parent.is_a?(Afisha)
      manage_review_path(parent) if parent.is_a?(Review)
    end
end
