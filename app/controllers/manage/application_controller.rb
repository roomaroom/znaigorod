class Manage::ApplicationController < InheritedResourcesController
  has_searcher

  layout 'manage'
end
