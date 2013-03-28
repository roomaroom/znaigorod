class SuborganizationsController < ApplicationController
  def index
    kind = (Organization.available_suborganization_kinds & [params[:kind]]).try(:first)
    klass = "#{kind.pluralize}_presenter".classify.constantize
    @presenter = klass.new(params)

    render partial: 'organizations/organizations_list', layout: false and return if request.xhr?
  end
end
