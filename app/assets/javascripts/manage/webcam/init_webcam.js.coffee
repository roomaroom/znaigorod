@init_webcam = () ->

  $('#webcam_snapshot_image').on 'change', ->
    $(this).parents('form').submit()
    true

  true

@init_webcam_map = () ->
  ymaps.ready ->

    $map = $('#webcam_map')

    map = new ymaps.Map $map[0],
      center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
      zoom: 12
      behaviors: ['drag', 'scrollZoom']
    ,
      maxZoom: 23
      minZoom: 12

    map.cursors.push('crosshair')

    map.controls.add 'zoomControl',
      top: 5
      left: 5

    if $('#webcam_latitude').val()
      latitude = $('#webcam_latitude').val()
    else
      latitude = 0
    if $('#webcam_longitude').val()
      longitude = $('#webcam_longitude').val()
    else
      longitude = 0

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
      $('#webcam_latitude').val("#{coordinates[0]}".substr(0,9))
      $('#webcam_longitude').val("#{coordinates[1]}".substr(0,9))
      map.geoObjects.each (geoObject) ->
        if (geoObject.properties.get('id') == 'placemark')
          geoObject.geometry.setCoordinates [coordinates[0], coordinates[1]]
        true
        true

    placemark.events.add 'dragend', (event) ->
      coordinates = placemark.geometry.getCoordinates()
      $('#webcam_latitude').val("#{coordinates[0]}".substr(0,9))
      $('#webcam_longitude').val("#{coordinates[1]}".substr(0,9))
      true

    true

  true
