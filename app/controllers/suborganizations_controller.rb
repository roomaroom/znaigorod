class SuborganizationsController < ApplicationController
  def index
    kind = (Organization.available_suborganization_kinds & [params[:kind]]).try(:first)
    klass = "#{kind.pluralize}_presenter".classify.constantize

    respond_to do |format|
      format.html {
        cookie = cookies['_znaigorod_organization_list_settings'].to_s
        settings_from_cookie = {}
        settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?
        @presenter = klass.new(settings_from_cookie.merge(params))
        render partial: 'organizations/organizations_posters', layout: false and return if request.xhr?
      }

      format.promotion {
        presenter = klass.new(params.merge(:per_page => 5))

        @collection = OrganizationDecorator.decorate(presenter.collection.map(&:organization))

        render :partial => 'promotions/organizations', :locals => { :presenter => presenter }
      }
    end
  end
end
