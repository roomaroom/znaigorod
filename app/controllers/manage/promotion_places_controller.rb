class Manage::PromotionPlacesController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:index, :show]

  belongs_to :promotion, :shallow => true
end
