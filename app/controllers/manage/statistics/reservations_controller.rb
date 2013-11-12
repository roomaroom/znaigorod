class Manage::Statistics::ReservationsController < Manage::ApplicationController
  load_and_authorize_resource

  def update
    reservation = Reservation.find(params[:id])
    reservation.add_price_to_balance

    redirect_to manage_statistics_sms_claims_path(:page => params[:page])
  end
end
