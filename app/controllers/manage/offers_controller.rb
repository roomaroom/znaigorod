class Manage::OffersController < Manage::ApplicationController
  load_and_authorize_resource

  actions :index, :edit, :update, :destroy
  custom_actions :resource => :fire_state_event

  has_scope :page, :default => 1
  has_scope :by_state, :only => :index

  def edit
    edit!{
      render :partial => 'form', :layout => false and return
    }
  end

  def update
    update!{
      render :partial => 'stake', :locals => { :offer => @offer }, :layout => false and return
    }
  end

  def fire_state_event
    fire_state_event! {
      resource.fire_state_event(params[:event]) if resource.state_events.include?(params[:event].to_sym)

      redirect_to request.referer and return
    }
  end

  private

  def collection
    @collection = Offer.search {
      with :state, params[:by_state] if params[:by_state].present?
      order_by :created_at, :desc
      paginate paginate_options.merge(:per_page => per_page)
    }.results
  end
end
