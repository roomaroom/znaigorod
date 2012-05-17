class MoviesController < InheritedResourcesController
  actions :index, :show

  layout 'public'
end
