class OffersController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :new, :create

  Discount.classes_subtree.map(&:name).map(&:underscore).each do |name|
    belongs_to name, :optional => true
  end

  def create
    create! do |success, failure|
      success.html { render @offer }
    end
  end

  protected

  def build_resource
    super
    @offer.account = current_user.account if current_user

    @offer
  end
end
