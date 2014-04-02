class Manage::PromotionsController < Manage::ApplicationController
  load_and_authorize_resource

  def index
    @promotions = Promotion.ordered
  end
end
