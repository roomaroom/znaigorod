class FeedsController < ApplicationController

  inherit_resources

  actions :index

  layout false
  def index
    index! {
      presenter = FeedsPresenter.new params
      @account = Account.find(presenter.account_id)
      @feeds = presenter.collection
      render @feeds and return
    }
  end

end
