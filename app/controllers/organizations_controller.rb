# encoding: utf-8

class OrganizationsController < ApplicationController
  has_scope :page, :default => 1

  def index
    @organizations_catalog_presenter = OrganizationsCatalogPresenter.new
  end

  def show
    unless request.subdomain.blank?
      @organization = OrganizationDecorator.find_by_subdomain!(request.subdomain)
    else
      @organization = OrganizationDecorator.find(params[:id])
    end

    @presenter = ShowingsPresenter.new(organization_ids: [@organization.id], order_by: params[:order_by], page: params[:page])

    render partial: @presenter.partial, layout: false and return if request.xhr?
    render layout: "organization_layouts/#{@organization.subdomain}" if @organization.subdomain? && template_exists?(@organization.subdomain, 'layouts/organization_layouts')
  end

  def photogallery
    @organization = OrganizationDecorator.find(params[:id])
  end

  def affiche
    @organization = OrganizationDecorator.find(params[:id])
    @presenter = AfficheCollection.new(params.merge(list_settings: cookies['znaigorod_affiches_list_settings']).merge(organization: @organization))
    render partial: @presenter.view_partial, layout: false and return if request.xhr?
  end

  def tour
    @organization = OrganizationDecorator.find(params[:id])
  end

  def in_bounding_box
    searcher = HasSearcher.searcher(:organizations, params).
      with_logotype.
      order_by_rating.
      paginate(page: 1, per_page: 100)

    data = OrganizationDecorator.decorate(searcher.results).map do |organization|
      {
        address: organization.address.to_s,
        id: organization.id,
        latitude: organization.address.latitude,
        logo: organization.logotype_url,
        longitude: organization.address.longitude,
        phones: organization.decorated_suborganizations.first.decorated_phones,
        schedule_today: organization.decorated_suborganizations.first.schedule_today,
        suborganization: organization.priority_suborganization_kind,
        title: organization.title,
        url: organization.show_url,
      }
    end

    render :json => data
  end
end
