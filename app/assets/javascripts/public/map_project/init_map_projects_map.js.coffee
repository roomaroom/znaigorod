@init_map_project = () ->

  ymaps.ready ->
    $map = $('.map_wrapper .map')
    map = new ymaps.Map $map[0],
      center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
      zoom: 12
      behaviors: ['drag', 'scrollZoom']
      maxZoom: 23
      minZoom: 12

    map.controls.add 'zoomControl',
      top: 5
      left: 5

    customItemContentLayout = ymaps.templateLayoutFactory.createClass("<h2 class=ballon_header>{{ properties.balloonContentHeader|raw }}</h2>" + "<div class=ballon_body>{{ properties.balloonContentBody|raw }}</div>" + "<div class=ballon_footer>{{ properties.balloonContentFooter|raw }}</div>")

    clusterer = new ymaps.Clusterer(
      clusterDisableClickZoom: true,
      clusterOpenBalloonOnClick: true,
      clusterBalloonContentLayout: 'cluster#balloonCarousel',
      clusterBalloonItemContentLayout: customItemContentLayout,
      clusterBalloonPanelMaxMapArea: 0,
      clusterBalloonContentLayoutWidth: 200,
      clusterBalloonContentLayoutHeight: 130,
      clusterBalloonPagerSize: 5
    )

    $('.map_projects_wrapper .placemarks_list p').each (index, item) ->
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
          hintContent: $(item).attr('data-title')
      ,
        iconLayout: 'default#image'
        iconImageHref: $(item).attr('data-icon')

      clusterer.add point

      true

    map.geoObjects.options.set
      showHintOnHover: false

    map.geoObjects.add clusterer

    true

  true
