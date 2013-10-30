class Manage::InvitationsController < Manage::ApplicationController
  def index
    invitations = Invitation.with_invited
    if params[:search] && params[:search]['starts_at'].present?
      @starts_at = Time.zone.parse(params[:search]['starts_at'])
    else
      @starts_at = invitations.first.created_at
    end

    if params[:search] && params[:search]['ends_at'].present?
      @ends_at = Time.zone.parse(params[:search]['ends_at'])
    else
      @ends_at = Time.zone.today
    end

    @invitations = invitations.starts_at(@starts_at.strftime('%Y-%m-%d')).ends_at(@ends_at.strftime('%Y-%m-%d'))
  end
end

