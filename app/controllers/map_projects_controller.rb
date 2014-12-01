class MapProjectsController < ApplicationController
  inherit_resources

  actions :index, :show

  layout 'map_projects'
end
