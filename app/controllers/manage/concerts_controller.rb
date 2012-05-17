class Manage::ConcertsController < Manage::ApplicationController
  actions :all, :except => :show

  has_scope :page, :default => 1

  def create
    create! {

      p '-------------------------------'
      p @concert.errors

      manage_concerts_path

    }
  end
end
