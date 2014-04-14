class HotelsController <  ApplicationController
  def index
    @presenter = HotelsPresenter.new
  end
end
