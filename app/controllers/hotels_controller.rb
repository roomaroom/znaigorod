class HotelsController <  ApplicationController
  def index
    @presenter = RoomsPresenter.new(:hotel, params)
    @organizations = Organization.joins(:hotel).select {|o| o.hotel.rooms.count == 0 }
  end
end
