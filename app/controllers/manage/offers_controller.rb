class Manage::OffersController < Manage::ApplicationController
  load_and_authorize_resource

  actions :index, :edit, :update, :destroy
  custom_actions :resource => :fire_state_event

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
end
