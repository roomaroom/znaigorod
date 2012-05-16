class Manage::AffichesController < Manage::ApplicationController
  actions :all

  has_scope :page, :default => 1
end
