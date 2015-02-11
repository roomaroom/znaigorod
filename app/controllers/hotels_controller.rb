class HotelsController <  ApplicationController
  helper_method :view_type

  def index
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
