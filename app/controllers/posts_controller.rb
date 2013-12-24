class PostsController < ApplicationController
  inherit_resources

  actions :index, :show

  has_scope :page, :default => 1

  def index
    @presenter = PostsPresenter.new(params)
    @posts = @presenter.decorated_collection
  end

  def show
    post_object = Post.find(params[:id])

    @post_images = Kaminari.paginate_array(post_object.images).page(params[:page]).per(30)

    if request.xhr?
      render :partial => 'post_images' and return
    else
      @presenter = PostsPresenter.new(params)
      @post = PostDecorator.new(post_object)

      @similar_posts = PostDecorator.decorate(@post.similar_posts)
      @post.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
    end
  end
end
