class Manage::PostImagesController < Manage::ApplicationController
  load_and_authorize_resource

  actions :new, :create, :destroy, :update, :edit

  belongs_to :post, :polymorphic => true, :optional => true
end
