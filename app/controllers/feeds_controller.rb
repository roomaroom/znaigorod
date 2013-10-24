class FeedsController < ApplicationController

  inherit_resources

  actions :index

  layout false
  def index
    index! {
      @feeds_presenter = FeedsPresenter.new params
      @account = Account.find(@feeds_presenter.account_id)
      @feeds = @feeds_presenter.collection
      render @feeds and return
    }
  end

end
