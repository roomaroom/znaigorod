class HotelsController <  ApplicationController
  def index
    @presenter = RoomsPresenter.new(params)
  end
end
