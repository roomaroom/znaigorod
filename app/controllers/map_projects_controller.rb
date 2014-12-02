class MapProjectsController < ApplicationController
  inherit_resources

  actions :index, :show

  layout 'map_projects'

  def show
    show! {
      @presenter = ReviewsPresenter.new(category: 'newyear', per_page: 100)
      @reviews = @presenter.decorated_collection
    }
  end
end
