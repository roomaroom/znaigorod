class FeedsController < ApplicationController

  inherit_resources

  actions :index

  layout false
  def index
    index! {
      presenter = FeedsPresenter.new params
      @account = current_user.account
      @feeds = presenter.collection
      if params['controller'] == 'feeds'
        render @feeds and return
      end

      if params['controller'] == 'my/feeds'
        render partial: 'my/feeds/feed', :collection => @feeds and return
      end
    }
  end

end
