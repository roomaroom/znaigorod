class Manage::Statistics::TicketsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :index

  belongs_to :afisha, optional: true

  def index
    @state = state = params[:state].present? ? params[:state] : nil
    page = params[:page].to_i.zero? ? 1 : params[:page]

    search = Copy.search(:include => :copyable) {
      keywords params[:q]
      group :copyable_id_str
      order_by :id, :desc
      paginate :page => page, :per_page => 10
      with :copyable_type, 'Ticket'
      with :state, state if state.present?
    }

    @groups = search.group(:copyable_id_str).groups
    @tickets = Ticket.where(:id => @groups.map(&:value)).order('id DESC')
  end
end