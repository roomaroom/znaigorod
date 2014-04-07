class Manage::PromotionsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:show]

  def index
    @promotions = Promotion.ordered
  end
end
