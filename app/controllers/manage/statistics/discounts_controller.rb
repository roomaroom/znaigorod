class Manage::Statistics::DiscountsController < Manage::ApplicationController
  authorize_resource :discount

  def index
    @state = state = params[:state].present? ? params[:state] : nil
    page = params[:page].to_i.zero? ? 1 : params[:page]

    search = Copy.search(:include => :copyable) {
      keywords params[:q]
      group :copyable_id_str
      order_by :id, :desc
      paginate :page => page, :per_page => 10
      with :copyable_type, 'Discount'
      with :state, state if state.present?
    }

    @groups = search.group(:copyable_id_str).groups
    discounts = Discount.where(:id => @groups.map(&:value)).order('id DESC')
    @grouped_discounts = GroupedDiscounts.new(discounts).grouped
  end
end
