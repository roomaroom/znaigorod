class Manage::Statistics::TicketsController < Manage::ApplicationController
  helper_method :zg_part, :organizations_part
  load_and_authorize_resource

  actions :new, :create, :edit, :update, :destroy

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

  def create
    create! { send("manage_#{parent.class.model_name.underscore}_path", parent) }
  end

  def ticket_statistic
    if params[:search] && params[:search]['starts_at'].present?
      @starts_at = Time.zone.parse(params[:search]['starts_at']).beginning_of_day
    else
      @starts_at = Time.zone.today.beginning_of_month
    end

    if params[:search] && params[:search]['ends_at'].present?
      @ends_at = Time.zone.parse(params[:search]['ends_at']).end_of_day
    else
      @ends_at = Time.zone.today.end_of_day
    end

    search = Copy.search(:include => :copyable) {
      group :copyable_id_str
      order_by :id, :desc
      paginate :page => page, :per_page => 10000
      with :copyable_type, 'Ticket'
      with :state, 'sold'
    }

    groups = search.group(:copyable_id_str).groups

    @tickets = Ticket.where(:id => groups.map(&:value))
                  .where('created_at >= ? and created_at <= ?', @starts_at, @ends_at)
                  .group_by(&:organization_title)
  end

  protected

  def zg_part(ticket)
    if ticket.payment_system == 'robokassa'
      ticket.price
    else
      ticket.price * 0.1
    end
  end

  def organizations_part(ticket)
    if ticket.payment_system == 'robokassa'
      0
    else
      ticket.price * 0.9
    end
  end
end
