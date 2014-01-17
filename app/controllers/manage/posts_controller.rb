class Manage::PostsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:new, :create]

  has_scope :page, :default => 1

  def show
    show! {
      @post = PostDecorator.decorate(@post)
    }
  end
end
