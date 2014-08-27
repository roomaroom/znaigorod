class My::AdvertsController < My::ApplicationController
  load_and_authorize_resource

  actions :all

  def create
    create! do |success, failure|
      success.html {
        redirect_to advert_path(resource.id)
      }

      failure.html {
        render :new
      }
    end
  end

  protected

  def begin_of_association_chain
    current_user.account
  end
end
