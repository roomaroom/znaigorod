class Manage::RoomsController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, :except => :index

  belongs_to :organization
  belongs_to :hotel, :singleton => true, :optional => true
  belongs_to :recreation_center, :singleton => true, :optional => true

  def destroy
    destroy! { [:manage, @organization] }
  end

  helper_method :context_type

  protected

  def collection
    @rooms = @rooms.where(context_type: context_type.classify)
  end

  def smart_collection_url
    [:manage, @organization, resource.context.class.name.underscore]
  end

  def context_type
    @context_type = request.url.
      split('/').
      select { |e| Organization.available_suborganization_kinds.include?(e) }.first.
      underscore
  end

  def build_resource
    super

    @room = @organization.send(context_type).rooms.new(params[:room])
  end
end

