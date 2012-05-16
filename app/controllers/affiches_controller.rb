class AffichesController < InheritedResourcesController
  actions :index, :show

  layout 'public'

  def index
  end
end
