class Manage::CommentsController < Manage::ApplicationController
  load_and_authorize_resource

  has_scope :page, :default => 1
  actions :index, :destroy

  def collection
    super.order('id desc').page(params[:page])
  end
end
