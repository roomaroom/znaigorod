class Manage::AttachmentsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :edit, :update

  layout false

  def update
    update! { render :json => @attachment.to_s.to_json and return }
  end
end
