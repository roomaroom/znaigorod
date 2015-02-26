class SaunasController < ApplicationController
  helper_method :view_type

  def index
    add_breadcrumb "Все организации", organizations_path
    add_breadcrumb 'Сауны', saunas_path

    cookies[:view_type] = params[:view_type] if params[:view_type]
    @presenter = SaunaHallsPresenter.new(params.merge(per_page: per_page))
    @discount_collection = SaunasDiscountsPresenter.new({}).collection
    @reviews = ReviewDecorator.decorate(review_list)

    if request.xhr?
      render partial: 'without_halls_list_view', layout: false and return if view_type == 'list'
      render partial: 'sauna_posters', layout: false
    end
  end

  def view_type
    cookies[:view_type] || 'list'
  end

  def per_page
    view_type == 'list' ? SaunaHallsPresenter.new(params).total_count : 9
  end

  def review_list
    OrganizationCategory.find_by_title(I18n.t("organization.kind.sauna")).reviews
  end
end
