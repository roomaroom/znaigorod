@init_map_project = () ->

  ymaps.ready ->
    $map = $('.map_wrapper .map')

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
