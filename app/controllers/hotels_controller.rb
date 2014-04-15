class HotelsController <  ApplicationController
  def index
    @presenter = RoomsPresenter.new(:hotel, params)
  end
end
