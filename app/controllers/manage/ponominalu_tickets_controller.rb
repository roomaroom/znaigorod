class Manage::PonominaluTicketsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => [:index, :show]

  belongs_to :afisha
end
