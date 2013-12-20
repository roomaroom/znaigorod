class My::PostsController < My::ApplicationController
  load_and_authorize_resource
  custom_actions :resource => :poster

  def show
    show!{
      @post = PostDecorator.new(@post)
    }
  end

  def update
    update! do |success, failure|
      success.html {
        if params[:crop]
          redirect_to poster_my_post_path(resource)
        else
          redirect_to my_post_path(resource)
        end
      }

      failure.html {
        render :poster and return if params[:crop]

        render :edit
      }
    end
  end

  def available_tags
    render :json => PostsTags.new(params[:term]).tags.to_json
  end

  def preview
    post = Post.new(params[:post])

    render :partial => 'posts/post_show', :locals => { :post => PostDecorator.new(post), :for_preview => true }
  end

  def link_with
    render :json => LinkWithAutocomplete.new(params[:term]).json
  end
end
