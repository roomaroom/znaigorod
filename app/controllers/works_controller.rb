class WorksController < ApplicationController
  inherit_resources

  actions :new, :create, :show

  belongs_to :contest
end
