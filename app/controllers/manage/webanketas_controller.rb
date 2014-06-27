class Manage::WebanketasController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => :index

  belongs_to :review, :optional => true

  def create
    create! { manage_review_webanketa_path(@review.id, @webanketa) }
  end

  def update
    update! { manage_review_webanketa_path(@review.id, @webanketa) }
  end

  def destroy
    destroy! { manage_review_path(@review.id) }
  end
end
