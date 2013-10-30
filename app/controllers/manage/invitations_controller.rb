class Manage::InvitationsController < Manage::ApplicationController
  def index
    if params[:search]
      starts_at = Time.zone.parse(params[:search]['starts_at'])
      ends_at = params[:search]['ends_at'].present? ? Time.zone.parse(params[:search]['ends_at']) : Time.zone.today

      @invitations = Invitation.with_invited.starts_at(starts_at.strftime('%Y-%m-%d')).ends_at(ends_at.strftime('%Y-%m-%d'))
    else
      @invitations = Invitation.with_invited
    end
  end
end

