class SuborganizationsController < ApplicationController
  def index
    kind = (Organization.available_suborganization_kinds & [params[:kind]]).try(:first)
    klass = "#{kind.pluralize}_presenter".classify.constantize

    respond_to do |format|
      format.html {
        cookie = cookies['_znaigorod_organization_list_settings'].to_s
        settings_from_cookie = {}
        per_page = Organization.where(status: :client).count
        settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?
        @presenter = klass.new(settings_from_cookie.merge(params.merge(per_page: per_page)))
        if request.xhr?
          render partial: 'organizations/organizations_posters', layout: false and return unless (@presenter.collection.last_page? && params[:not_client_page].present? )
          render partial: 'organizations/not_client_posters', layout: false
        end
      }

      format.promotion {
        presenter = klass.new(params.merge(:per_page => 5))

        @collection = OrganizationDecorator.decorate(presenter.collection.map(&:organization))

        render :partial => 'promotions/organizations', :locals => { :presenter => presenter }
      }
    end
  end
end
