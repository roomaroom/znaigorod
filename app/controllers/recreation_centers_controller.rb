class RecreationCentersController <  ApplicationController
  def index
    @presenter = RoomsPresenter.new(:recreation_center, params)
  end
end
