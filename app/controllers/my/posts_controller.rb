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
    render :json => %w[foo bar foobar].to_json
  end

  def preview
    render :text => AutoHtmlRenderer.new(params[:text]).render_show(:youtube => { :width => 560 })
  end

  def link_with
    render :json => LinkWithAutocomplete.new(params[:term]).json
  end
end
