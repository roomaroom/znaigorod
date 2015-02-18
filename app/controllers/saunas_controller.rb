class SaunasController < ApplicationController
  helper_method :view_type

  def index
    add_breadcrumb "Все организации", organizations_path
    add_breadcrumb 'Сауны', saunas_path

    cookies[:view_type] = params[:view_type] if params[:view_type]
    @presenter = SaunaHallsPresenter.new(params.merge(per_page: per_page))
    @discount_collection = SaunasDiscountsPresenter.new({}).collection
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
end
