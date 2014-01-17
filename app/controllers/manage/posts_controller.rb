class Manage::PostsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all

  def show
    show! {
      @post = PostDecorator.decorate(@post)
    }
  end
end
