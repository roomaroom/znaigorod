class FeedsController < ApplicationController

  inherit_resources

  actions :index

  layout false
#TODO should be refactored
  def index
    index! {
      presenter = FeedsPresenter.new params
      @feeds = presenter.collection
    render @feeds and return
    }
  end

end
