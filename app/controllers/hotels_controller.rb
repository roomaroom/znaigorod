class HotelsController <  ApplicationController
  helper_method :view_type

  def index
    add_breadcrumb "Все организации", organizations_path
    add_breadcrumb "Базы отдыха и гостиницы", hotels_path
    add_breadcrumb params[:categories].first.mb_chars.capitalize, send("hotels_#{params[:categories].first.from_russian_to_param.pluralize}_path") if params[:categories]
    @presenter = RoomsPresenter.new(:hotel, params.merge(per_page: per_page))
    if request.xhr?
      render partial: 'without_rooms_list_view', layout: false and return if view_type == 'list'
      render partial: 'housings/housing_posters', :locals => { :housing => :hotel }, layout: false
    end
  end

  def view_type
    params[:view_type] || 'list'
  end

  def per_page
    view_type == 'list' ? RoomsPresenter.new(:hotel, params).total_count : 9
  end
end
