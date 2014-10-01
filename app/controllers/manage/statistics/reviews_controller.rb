class Manage::Statistics::ReviewsController < Manage::ApplicationController
  load_and_authorize_resource

  has_scope :page, :default => 1

  def index
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

    author_ids = %w[4649, 6, 2303, 8581, 18960]
    @reviews = Review.where(:account_id => author_ids, state: 'published').where('created_at >= ? and created_at <= ?', @starts_at, @ends_at).group_by(&:account_id)
  end
end
