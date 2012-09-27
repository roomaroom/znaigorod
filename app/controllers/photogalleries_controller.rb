class PhotogalleriesController < ApplicationController
  has_scope :page, :default => 1

  def index
    @photogallery = Photogallery.new(params)
    render partial: 'photogalleries_list', layout: false and return if request.xhr?
  end
end
