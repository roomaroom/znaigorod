class FeedsController < ApplicationController

  inherit_resources

  actions :index

  layout false

  def index
    index! {
      @feeds = end_of_association_chain.page(params[:page]).per(30)
      render @feeds and return
    }
  end

end
