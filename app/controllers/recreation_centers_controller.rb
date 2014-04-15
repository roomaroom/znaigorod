class RecreationCentersController <  ApplicationController
  def index
    @presenter = RoomsPresenter.new(:recreation_center, params)
    render partial: 'housings/housing_posters', :locals => { :housing => :recreation_center }, layout: false and return if request.xhr?
  end
end
