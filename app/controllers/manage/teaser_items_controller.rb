class Manage::TeaserItemsController < Manage::ApplicationController
  load_and_authorize_resource

  def update
    update! do |success, failure|
      success.html { redirect_to manage_teaser_path(resource.teaser)}
      failure.html { render :edit }
    end
  end
end
