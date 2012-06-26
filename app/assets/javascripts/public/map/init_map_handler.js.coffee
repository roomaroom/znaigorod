map_for_index = () ->
  container = $('<div class="map_container" style="width:640px; height: 480px;" />').appendTo('body').hide()
  $('.show_map_link').live 'click', ->
    link = $(this)
    longitude = link.attr('longitude')
    latitude = link.attr('latitude')
    map = container.dialog(
      draggable: false
      height: 480
      resizable: false
      title: link.prev('.address').html()
      width: 640
      zIndex: 700
      close: ->
        map.destroy()
        map = null
    ).draw_map(longitude, latitude)

    false

map_for_show = () ->
  container = $('.map_container')
  longitude = container.attr('longitude')
  latitude  = container.attr('latitude')
  container.draw_map(longitude, latitude)

map_for_location = ->
  container = $('.map_container')
  lon = container.attr('data-lon')
  lat  = container.attr('data-lat')
  map = container.draw_map(lon, lat, 12)
  marker = map.markers.getAll()[0]
  marker.hide()
  map.addEventListener map.getContainerId(), 'DgClick', (evt) ->
    console.log evt.getGeoPoint()
    marker.setPosition evt.getGeoPoint()
    marker.show()
    map.geometries.removeAll()
    map.geometries.add(new DG.Geometries.Circle evt.getGeoPoint(), 150, new DG.Style.Geometry)

  $(".by_location form.search_location").submit ->
    form = $(this)
    street = $("#search_location_street", form).val()
    house = $("#search_location_house", form).val()
    $.ajax '/geocoder',
      async: false
      dataType: 'json'
      data: "street=#{street}"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(errorThrown)
      success: (data, textStatus, jqXHR) ->
        json = jQuery.parseJSON jqXHR.responseText
        if json.response_code == "200"
          position = new DG.GeoPoint(json.longitude, json.latitude)
          marker.setPosition position
          marker.show()
          map.setCenter position, 16
        else
          # TODO показать сообщение об ошибке

    return false

$.fn.draw_map = (longitude, latitude, scale = 16) ->
  container = this[0]
  point = new DG.GeoPoint(longitude, latitude)
  map = new DG.Map(container)
  marker = new DG.Markers.Common({ geoPoint: point })
  map.controls.add(new DG.Controls.Zoom())
  map.setCenter(point, scale)
  map.markers.add(marker)
  return map

@init_map_handler = () ->
  map_for_show() if $('.show .map_container').length
  map_for_index() if $('.show_map_link').length
  map_for_location() if $('.by_location').length
