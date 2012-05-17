class ConcertsController < InheritedResourcesController
  actions :index, :show

  layout 'public'
end
