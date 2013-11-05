class Manage::ServicesController < Manage::ApplicationController
  load_and_authorize_resource

  actions :all, except: [:index, :show]

  belongs_to :organization

  Organization.available_suborganization_kinds do |kind|
    belongs_to kind, singleton: true
  end

  helper_method :context_type

  protected

  def collection
    @services = @services.where(context_type: context_type.classify)
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

    @service = @organization.send(context_type).services.new(params[:service])
  end
end
