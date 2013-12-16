class My::AutoHtmlController < ApplicationController
  layout false

  def to_html
    render :text => AutoHtmlRenderer.new(params[:text]).render
  end
end
