class SuborganizationsController < ApplicationController
  helper_method :view_type

  def index
    add_breadcrumb "Все организации", organizations_path
    add_breadcrumb I18n.t(params[:kind]), send("#{params[:kind].pluralize}_path") if params[:kind]
    add_breadcrumb params[:categories].first.mb_chars.capitalize, send("#{params[:kind].pluralize}_#{params[:categories].first.from_russian_to_param.pluralize}_path") if params[:categories]

    kind = (Organization.available_suborganization_kinds & [params[:kind]]).try(:first)
    klass = "#{kind.pluralize}_presenter".classify.constantize

    respond_to do |format|
      format.html {
        cookie = cookies['_znaigorod_organization_list_settings'].to_s
        cookies[:view_type] = params[:view_type] if params[:view_type]
        settings_from_cookie = {}
        settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?
        @presenter = klass.new(settings_from_cookie.merge(params.merge(per_page: per_page)))

        if request.xhr?
          if view_type == 'list'
            render partial: 'suborganizations/not_client_list_view', layout: false
          else
            render partial: 'organizations/organizations_posters', layout: false and return unless (@presenter.collection.last_page? && params[:not_client_page].present? )
            render partial: 'organizations/not_client_posters', layout: false
          end
        end
      }

      format.promotion {
        presenter = klass.new(params.merge(:per_page => 5))

        @collection = OrganizationDecorator.decorate(presenter.collection.map(&:organization))

        render :partial => 'promotions/organizations', :locals => { :presenter => presenter }
      }
    end
  end

  def view_type
    cookies[:view_type] || 'list'
  end

  def per_page
    kind = (Organization.available_suborganization_kinds & [params[:kind]]).try(:first)
    klass = "#{kind.pluralize}_presenter".classify.constantize
    view_type =='list' ? klass.new(params).total_count : 14
  end
end
