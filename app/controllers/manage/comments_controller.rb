class Manage::CommentsController < Manage::ApplicationController
  load_and_authorize_resource

  has_scope :page, :default => 1
  actions :index, :destroy

  def collection
    super.order('id desc').page(params[:page])
  end

  def destroy
    destroy! {
      render text: '200', layout: false, status: 200 and return if request.xhr?

      redirect_to manage_comments_path and return
    }
  end
end
