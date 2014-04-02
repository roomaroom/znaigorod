class Manage::PlaceItemsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:index, :show]

  belongs_to :promotion, :shallow => true
  belongs_to :promotion_place

  protected

  def parent_url
    [:manage, @promotion]
  end
end
