class My::FeedsController < ApplicationController

  inherit_resources

  actions :index

  layout false
  def index
    index! {
      presenter = FeedsPresenter.new params
      @account = current_user.account
      @feeds = presenter.collection
      render partial: 'my/feeds/feed', :collection => @feeds and return
    }
  end

end
