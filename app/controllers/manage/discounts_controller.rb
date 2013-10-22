class Manage::DiscountsController < Manage::ApplicationController
  actions :all
  custom_actions :resource => :fire_state_event

  def update
    update! do |success, failure|
      success.html {
        if params[:crop]
          redirect_to poster_manage_discount_path(resource)
        else
          redirect_to manage_discount_path(resource)
        end
      }

      failure.html {
        render :poster and return if params[:crop]

        render :edit
      }
    end
  end

  def fire_state_event
    fire_state_event! {
      resource.fire_state_event(params[:event]) if resource.state_events.include?(params[:event].to_sym)

      redirect_to manage_discount_path(resource.id), :notice => resource.errors.full_messages and return unless resource.errors.messages.empty?
      redirect_to manage_discount_path(resource) and return
    }
  end

  private

  def collection
    @collection = Discount.page(params[:page] || 1).per(10)
  end
end
