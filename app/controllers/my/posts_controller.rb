class My::PostsController < My::ApplicationController
  load_and_authorize_resource

  def show
    show!{
      @post = PostDecorator.new(@post)
    }
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
