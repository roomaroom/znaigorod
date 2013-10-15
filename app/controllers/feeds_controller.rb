class FeedsController < ApplicationController

  inherit_resources

  actions :index

  layout false

  def index
    index! {
      unless params[:kind].nil? || (params[:kind] == 'all')
        @feeds = end_of_association_chain.where(:feedable_type => params[:kind].capitalize, :account_id => params[:account_id]).order('created_at DESC').page(params[:page]).per(10)
      else
        @feeds = end_of_association_chain.where(:account_id => params[:account_id]).order('created_at DESC').page(params[:page]).per(10)
      end
    render @feeds and return
    }
  end

end
