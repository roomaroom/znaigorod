class Manage::AffichesController < Manage::ApplicationController
  actions :index, :new

  has_scope :page, :default => 1
end
