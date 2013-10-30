class EventsController < ApplicationController
  inherit_resources

  belongs_to :account

  layout false

  def index
    index! {
      render partial: 'events/account_events', locals: { events: @events, :state => params[:by_state] }, layout: false and return
    }
  end

  private

  def collection
    if params[:by_state].present?
      @events = super.by_state(params[:by_state]).page(params[:page]).per(15)
    else
      @events = current_user.account.afisha.page(params[:page]).per(15)
    end
    @events
  end
end
