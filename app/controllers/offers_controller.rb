class OffersController < ApplicationController
  inherit_resources

  actions :new, :create

  Discount.classes_subtree.map(&:name).map(&:underscore).each do |name|
    belongs_to name, :optional => true
  end

  def create
    raise params.inspect
  end
end
