class Manage::SaunasController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  before_filter :build_nested_objects, :only => [:new, :edit]

  def index
    @collection = Sauna.page(params[:page] || 1).per(10)
  end

  private

  def build_nested_objects
    resource.virtual_tour || resource.build_virtual_tour
  end
end
