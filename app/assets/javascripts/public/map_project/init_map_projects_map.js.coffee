@init_map_project = () ->

  ymaps.ready ->
    $map = $('.map_wrapper .map')
    map = new ymaps.Map $map[0],
      center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
      zoom: 11
      behaviors: ['drag', 'scrollZoom']
      controls: []
    ,
      maxZoom: 23
      minZoom: 11

    map.controls.add 'fullscreenControl',
      float: 'none'
      position:
        top: 10
        left: 10

    map.controls.add 'geolocationControl',
      float: 'none'
      position:
        top: 50
        left: 10

    map.controls.add 'zoomControl',
      float: 'none'
      position:
        top: 90
        left: 10

    clusterer = new ymaps.Clusterer
      clusterDisableClickZoom: true
      clusterBalloonContentLayout: 'cluster#balloonAccordion'
      balloonAccordionShowIcons: false
      clusterBalloonContentLayoutWidth: 220

    $('.map_projects_wrapper .placemarks_list p').each (index, item) ->
      link = $('a', item)
      title = link.text()

      img_width = 190
      img_height = 190
      if $(item).attr('data-type') == 'afisha'
        img_height = 260

      point = new ymaps.GeoObject
        geometry:
          type: 'Point'
          coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]
        properties:
          balloonContentHeader: "" +
            "<div class='balloon_content_header' style='margin-bottom:5px;font-size:12px;padding-right:33px;'>" +
            title +
            "</div>"
          balloonContentBody: "" +
            "<div class='ymaps-2-1-17-b-cluster-content__body'>" +
            "<a href='#{link.attr('href')}' target='_blank' class='balloon_link' data-id='balloon_link_id_'>" +
            "<img width='#{img_width}' height='#{img_height}' src='#{$(item).attr('data-image')}' />" +
            "</a>" +
            "</div>"
          hintContent: title
      ,
        balloonMinWidth: 220
        balloonMaxWidth: 220
        #iconLayout: 'default#image'
        #iconImageHref: $(item).attr('data-icon')

      clusterer.add point

      true

    map.geoObjects.options.set
      showHintOnHover: false

    map.geoObjects.add clusterer

    true

  true
