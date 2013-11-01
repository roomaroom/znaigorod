class My::FeedsController < ApplicationController

  inherit_resources

  actions :index

  layout false
  def index
    index! {
      @feeds_presenter = FeedsPresenter.new params
      @feeds = @feeds_presenter.collection
      render partial: 'my/feeds/feed', :collection => @feeds and return
    }
  end

end
