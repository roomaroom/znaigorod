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

$.fn.draw_map = (longitude, latitude) ->
  container = this[0]
  point = new DG.GeoPoint(longitude, latitude)
  map = new DG.Map(container)
  marker = new DG.Markers.Common({ geoPoint: point })
  scale = 16
  DG.autoload ->
  map.controls.add(new DG.Controls.Zoom())
  map.setCenter(point, scale)
  map.markers.add(marker)
  return map

@init_map_handler = () ->
  map_for_index() if $('.index .show_map_link').length
  map_for_show() if $('.show .map_container').length
