class GeocoderController < ApplicationController
  layout false

  def get_coordinates
    render :json => Geocoder.get_coordinates(params[:street], params[:house]) and return
  end

  def get_yamp_coordinates
    render :json => YampGeocoder.get_coordinates(params[:street], params[:house]) and return
  end

  def get_yamp_house_photo
    render :json => YampGeocoder.get_house_photo(params[:coords]) and return
  end

  def geo_info
    render :json => YampGeocoder.new.geo_info_for(params[:address])
  end
end

