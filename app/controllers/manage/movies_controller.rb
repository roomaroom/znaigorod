class Manage::MoviesController < Manage::ApplicationController
  actions :all, :except => :show

  has_scope :page, :default => 1

  def create
    create!{ resource_path }
  end

  def update
    update!{ resource_path }
  end
end
