class HotelsController <  ApplicationController
  helper_method :view_type

  def index
    add_breadcrumb "Все организации", organizations_path
    add_breadcrumb "Базы отдыха и гостиницы", hotels_path
    add_breadcrumb params[:categories].first.mb_chars.capitalize, send("hotels_#{params[:categories].first.from_russian_to_param.pluralize}_path") if params[:categories]

    cookies[:view_type] = params[:view_type] if params[:view_type]
    @presenter = RoomsPresenter.new(:hotel, params.merge(per_page: per_page))
    @reviews = ReviewDecorator.decorate(review_list)

    if request.xhr?
      render partial: 'without_rooms_list_view', layout: false and return if view_type == 'list'
      render partial: 'housings/housing_posters', :locals => { :housing => :hotel }, layout: false
    end
  end

  def view_type
    cookies[:view_type] || 'list'
  end

  def per_page
    view_type == 'list' ? RoomsPresenter.new(:hotel, params).total_count : 9
  end

  def review_list
    return OrganizationCategory.find_by_title(params[:categories].first.mb_chars.capitalize).reviews if params[:categories]
    OrganizationCategory.find_by_title(I18n.t("organization.kind.hotel")).children.flat_map(&:reviews).uniq
  end
end
