class HotelsController <  ApplicationController
  def index
    @presenter = HotelsPresenter.new
    @organizations = Organization.joins(:hotel)
  end
end
