class Manage::OffersController < Manage::ApplicationController
  load_and_authorize_resource

  actions :index, :destroy
  custom_actions :resource => :fire_state_event

  def fire_state_event
    fire_state_event! {
      resource.fire_state_event(params[:event]) if resource.state_events.include?(params[:event].to_sym)

      redirect_to request.referer and return
    }
  end
end
