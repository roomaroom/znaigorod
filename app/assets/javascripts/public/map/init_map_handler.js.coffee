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
  map = container.draw_map(lon, lat, 11)
  marker = map.markers.getAll()[0]
  min_radius = 150
  $(".search_radius_wrapper .min_max .min").text(min_radius)
  max_radius = 3000
  $(".search_radius_wrapper .min_max .max").text(max_radius)
  current_radius = 600
  $(".search_radius_wrapper .info .counter").text(current_radius)
  $(".search_radius_wrapper .info .speed").text("(пешком ~#{manyralize(Math.round(current_radius * 60 / 5000), { one: 'минута', few: 'минуты', many: 'минут' })})")
  marker.hide()
  circle_geometry = new DG.Style.Geometry
  circle_geometry.strokeColor = '#999'
  circle_geometry.strokeWidth = 2
  circle = new DG.Geometries.Circle marker.getPosition(), current_radius
  $(".DGControlsCopyright", container).remove()
  map.addEventListener map.getContainerId(), 'DgClick', (evt) ->
    marker.setPosition evt.getGeoPoint()
    marker.show()
    map.setCenter evt.getGeoPoint()
    map.geometries.removeAll()
    circle = new DG.Geometries.Circle marker.getPosition(), current_radius
    map.geometries.add(circle, circle_geometry)
    $(".search_radius_wrapper").show()

  $(".by_location form.search_location").submit ->
    form = $(this)
    $(".actions li.error", form).remove()
    street = $("#search_location_street", form).val()
    house = $("#search_location_house", form).val()
    $.ajax '/geocoder',
      async: false
      dataType: 'json'
      data: "street=#{street}"
      error: (jqXHR, textStatus, errorThrown) ->
        console.log(errorThrown)
      success: (data, textStatus, jqXHR) ->
        json = $.parseJSON jqXHR.responseText
        if json.response_code == "200"
          position = new DG.GeoPoint(json.longitude, json.latitude)
          marker.setPosition position
          marker.show()
          map.setCenter position
          map.geometries.removeAll()
          circle = new DG.Geometries.Circle position, current_radius
          map.geometries.add(circle, circle_geometry)
          $(".search_radius_wrapper").show()
        else
          marker.hide()
          map.geometries.removeAll()
          button_wrapper = $(".actions input", form).closest("ol")
          $("<li class='error'>Не найдено</li>").appendTo(button_wrapper)
          $(".search_radius_wrapper").hide()

    return false

  $("#search_radius_slider").slider
    range: "min"
    min: min_radius
    max: max_radius
    step: 150
    value: current_radius
    slide: (event, ui) ->
      current_radius = ui.value
      circle.setRadius(current_radius)
      $(".search_radius_wrapper .info .counter").text(current_radius)
      $(".search_radius_wrapper .info .speed").text("(пешком ~#{manyralize(Math.round(current_radius * 60 / 5000), { one: 'минута', few: 'минуты', many: 'минут' })})")

manyralize = (num, cases) ->
  num = Math.abs(num)
  word = ""
  if num.toString().indexOf(".") > -1
    word = cases.few
  else
    word = (if num % 10 is 1 and num % 100 isnt 11 then cases.one else (if num % 10 >= 2 and num % 10 <= 4 and (num % 100 < 10 or num % 100 >= 20) then cases.few else cases.many))
  "#{num} #{word}"

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
