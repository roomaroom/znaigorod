class HotelsController <  ApplicationController
  def index
    @presenter = RoomsPresenter.new(:hotel, params)
    render partial: 'housings/housing_posters', :locals => { :housing => :hotel }, layout: false and return if request.xhr?
  end
end
