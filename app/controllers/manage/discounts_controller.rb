class Manage::DiscountsController < Manage::ApplicationController
  actions :all
  custom_actions :resource => :destroy_image

  def update
    update! do |success, failure|
      success.html {
        if params[:crop]
          redirect_to poster_manage_discount_path(resource)
        else
          redirect_to manage_discount_path(resource)
        end
      }

      failure.html {
        render :poster and return if params[:crop]

        render :edit
      }
    end
  end

  def destroy_image
    destroy_image! {
      resource.poster_url = nil
      resource.poster_image.destroy
      resource.poster_image_url = nil
      resource.save(:validate => false)
      redirect_to poster_manage_discount_path(resource) and return
    }
  end

  private

  def collection
    @collection = Discount.page(params[:page] || 1).per(10)
  end
end
