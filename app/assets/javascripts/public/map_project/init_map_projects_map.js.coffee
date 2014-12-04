@init_map_project = () ->

  ymaps.ready ->
    $map = $('.map_wrapper .map')
    map = new ymaps.Map $map[0],
      center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
      zoom: 12
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

    cluster_html = "" +
      "<div class=ballon_body>{{ properties.balloonContentBody|raw }}</div>" +
      "<div class=ballon_footer>{{ properties.balloonContentFooter|raw }}</div>"

    customItemContentLayout = ymaps.templateLayoutFactory.createClass(cluster_html)

    clusterer = new ymaps.Clusterer(
      clusterDisableClickZoom: true,
      clusterOpenBalloonOnClick: true,
      clusterBalloonContentLayout: 'cluster#balloonCarousel',
      clusterBalloonItemContentLayout: customItemContentLayout,
      clusterBalloonPanelMaxMapArea: 0,
      clusterBalloonContentLayoutWidth: 220,
      clusterBalloonContentLayoutHeight: 240,
      clusterBalloonPagerSize: 5
    )

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
            "<center style='margin-bottom:5px;font-size:12px;width:190px'>" +
            "<a href='#{link.attr('href')}' target='_blank' class='balloon_link' data-id='balloon_link_id_'>" +
            title +
            "</a>" +
            "</center>"
          balloonContentBody: "" +
            "<center>" +
            "<a href='#{link.attr('href')}' target='_blank' class='balloon_link' data-id='balloon_link_id_'>" +
            "<img width='#{img_width}' height='#{img_height}' src='#{$(item).attr('data-image')}' />" +
            "</a>" +
            "</center>"
          hintContent: title
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
