class Manage::Statistics::ReviewsController < Manage::ApplicationController
  load_and_authorize_resource

  has_scope :page, :default => 1

  def index
    author_ids = %w[4649, 6, 2303, 8581, 18960]
    @reviews = Review.where(:account_id => author_ids, state: 'published').group_by(&:account_id)
  end
end
