@init_map_project = () ->

  ymaps.ready ->
    $map = $('.map_project_wrapper .map_project_map')

    map = new ymaps.Map $map[0],
      center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
      zoom: 12
      behaviors: ['drag', 'scrollZoom']
    ,
      maxZoom: 23
      minZoom: 12

    map.controls.add 'zoomControl',
      top: 5
      left: 5

    $('.map_project_wrapper .placemarks_list p').each (index, item) ->
      link = $('a', item)
      title = link.text()

      img_width = 200
      if $(item).attr('data-image').match /stream/
        img_height = 112
      else
        img_height = 150

      point = new ymaps.GeoObject
        geometry:
          type: 'Point'
          coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]
        properties:
          balloonContentHeader: "" +
            "<center style='margin-bottom:5px;font-size:12px; width:200px'>" +
            "<a href='#{link.attr('href')}' target='_blank' class='balloon_link' data-id='balloon_link_id_'>" +
            $(item).attr('data-title') +
            "</a>" +
            "</center>"
          balloonContentBody: "" +
            "<center>" +
            "<a href='#{link.attr('href')}' target='_blank' class='balloon_link' data-id='balloon_link_id_'>" +
            "<img width='#{img_width}' height='#{img_height}' src='#{$(item).attr('data-image')}' />" +
            "</a>" +
            "<br />" +
            "</center>"
          hintContent: title
      ,
        iconImageHref: $(item).attr('data-icon')
        console.log $(item).attr('data-icon')
        #iconImageOffset: [-15, -40]
        #iconImageSize: [37, 42]

      map.geoObjects.add point

      true

    map.geoObjects.options.set
      showHintOnHover: false

    map.geoObjects.events.add 'mouseenter', (event) ->
      geoObject = event.get('target')
      position = event.get('globalPixelPosition')
      balloon = geoObject.balloon.open(position)
      balloon.events.add 'mouseleave', ->
        balloon.close()
        true
      true

    true

  true

@init_map_placemark = () ->
  $.fn.add_click_handler = () ->
    $this = $(this)
    $this.click ->
      if $('.map_wrapper').length
        container = $('.map_wrapper')
      else
        container = $('<div class="map_wrapper" style="width:640px; height: 480px;" />').appendTo('body').hide()
      latitude = $('#map_placemark_latitude', $(this).parent())
      longitude = $('#map_placemark_longitude', $(this).parent())
      coordinates = { 'latitude': latitude.val(), 'longitude': longitude.val() }
      map = null

      container.dialog
        draggable: false
        height: 480
        modal: true
        resizable: false
        title: 'Укажите координаты места проведения'
        width: 640
        zIndex: 700
        open: ->
          map = container.draw_map($this, coordinates)
        close: ->
          map.destroy()
      false

    true

  $.fn.draw_map = (link, coordinates) ->
    $map = $(this)
    latitude = coordinates.latitude || '56.488611121111'
    longitude = coordinates.longitude || '84.952222232222'
    map = new ymaps.Map $map[0],
      center: [latitude, longitude]
      zoom: 16
      behaviors: ['drag', 'scrollZoom']
    ,
      maxZoom: 23
      minZoom: 12

    map.controls.add 'zoomControl',
      top: 5
      left: 5

    placemark = new ymaps.GeoObject
      geometry:
        type: 'Point'
        coordinates: [latitude, longitude]
      properties:
        id: 'placemark'
    ,
      draggable: true
      iconImageHref: '/assets/public/afisha_placemark.png'
      iconImageOffset: [-15, -40]
      iconImageSize: [37, 42]

    map.geoObjects.add(placemark)

    map.events.add 'click', (event) ->
      coordinates = event.get('coordPosition')
      $('#map_placemark_latitude', $(link).parent()).val(coordinates[0]).change()
      $('#map_placemark_longitude', $(link).parent()).val(coordinates[1]).change()
      $(link).addClass('with_coordinates')
      map.geoObjects.each (geoObject) ->
        if (geoObject.properties.get('id') == 'placemark')
          geoObject.geometry.setCoordinates [coordinates[0], coordinates[1]]
        true
      true

    placemark.events.add 'dragend', (event) ->
      coordinates = placemark.geometry.getCoordinates()
      $('#map_placemark_latitude', $(link).parent()).val(coordinates[0]).change()
      $('#map_placemark_longitude', $(link).parent()).val(coordinates[1]).change()
      $(link).addClass('with_coordinates')
      true

    map


  link = $('.choose_coordinates')

  link.each ->

    $(this).add_click_handler()
    true

  true
