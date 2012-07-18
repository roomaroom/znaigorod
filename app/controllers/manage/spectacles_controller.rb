class Manage::SpectaclesController < Manage::ApplicationController
  actions :all, :except => :show

  has_scope :page, :default => 1
end
