@init_affiche_yandex_map = () ->

  ymaps.ready ->

    $map = $('.yandex_map .map')

    without_organization_id = $map.attr('data-without-id')

    map = new ymaps.Map $map[0],
      center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
      zoom: 15
      behaviors: []

    zoomButton = new ymaps.control.Button
      data:
        image: '/assets/public/affiche_icon_magnifier.png'
        title: 'Нажмите для увеличения карты'
    ,
      selectOnClick: false
      position:
        left: 5
        top: 5

    zoomButton.events.add 'click', (event) ->
      init_modal_affiche_yandex_map()

    map.controls.add(zoomButton)

    affiche_placemark = new ymaps.GeoObject
      geometry:
        type: 'Point'
        coordinates: [$map.attr('data-latitude'), $map.attr('data-longitude')]
      properties:
        hintContent: $map.attr('data-hint')
    ,
      cursor: 'help'
      hasBalloon: false
      iconImageHref: '/assets/public/affiche_placemark.png'
      iconImageOffset: [-18, -40]
      iconImageSize: [37, 42]
      zIndex: 1000
      zIndexHover: 1100

    map.geoObjects.add(affiche_placemark)

    true

  true

@init_modal_affiche_yandex_map = () ->

  dialog_width = $(window).innerWidth() * 70 / 100
  dialog_height = $(window).innerHeight() * 80 /100

  ymaps.ready ->

    $('<div id=\'modal_affiche_yandex_map\'></div>').dialog
      width: dialog_width
      height: dialog_height
      modal: true
      resizable: false
      open: (event, ui) ->
        $map = $(this)
        $map.attr('data-latitude', $('.yandex_map .map').attr('data-latitude'))
        $map.attr('data-longitude', $('.yandex_map .map').attr('data-longitude'))
        $map.attr('data-hint', $('.yandex_map .map').attr('data-hint'))
        without_organization_id = $('.yandex_map .map').attr('data-without-id')
        map = new ymaps.Map this,
          center: [$('.yandex_map .map').attr('data-latitude'), $('.yandex_map .map').attr('data-longitude')]
          zoom: 15
          behaviors: ['drag', 'scrollZoom']
        ,
          maxZoom: 23
          minZoom: 12

        affiche_placemark = new ymaps.GeoObject
          geometry:
            type: 'Point'
            coordinates: [$map.attr('data-latitude'), $map.attr('data-longitude')]
          properties:
            id: 'affiche_placemark'
            hintContent: $map.attr('data-hint')
        ,
          cursor: 'help'
          hasBalloon: false
          iconImageHref: '/assets/public/affiche_placemark.png'
          iconImageOffset: [-18, -42]
          iconImageSize: [37, 42]
          zIndex: 700

        map.geoObjects.add(affiche_placemark)

        map.controls.add 'zoomControl',
          top: 5
          left: 5

        render_organizations(map, without_organization_id)

        map.events.add 'actionend', (event) ->
          render_organizations(map, without_organization_id)
          true

        true

      close: (event, ui) ->
        $(this).parent().remove()
        $(this).remove()
        true

    true

  true

render_organizations = (map, without_organization_id) ->

  a_x = map.getBounds()[0][0]
  a_y = map.getBounds()[0][1]
  b_x = map.getBounds()[1][0]
  b_y = map.getBounds()[1][1]

  link = "/organizations/in_bounding_box?location[ax]=#{a_x}&location[ay]=#{a_y}&location[bx]=#{b_x}&location[by]=#{b_y}"
  link += "&without=#{without_organization_id}" if without_organization_id?

  $.ajax
    type: 'GET'
    url: link
    success: (data, textStatus, jqXHR) ->
      builded_placemarks = {}
      builded_placemark_ids = []
      freezed_placemarks = {}
      need_delete_placemarks = []

      $.each data, (index, item) ->
        unless item.logo.isBlank()
          builded_placemarks["id_#{item.id}"] = build_placemark(item)
          builded_placemark_ids.add "id_#{item.id}"
        true

      map.geoObjects.each (geoObject) ->
        return true if geoObject.properties.get('id').compact() == 'affiche_placemark'
        if builded_placemark_ids.indexOf(geoObject.properties.get('id')) != -1
          freezed_placemarks[geoObject.properties.get('id').compact()] = geoObject
        else
          need_delete_placemarks.add geoObject
        true

      $.each data, (index, item) ->
        return true if freezed_placemarks["id_#{item.id}"]
        map.geoObjects.add builded_placemarks["id_#{item.id}"]
        true

      $.each need_delete_placemarks, (index, item) ->
        map.geoObjects.remove item
        true

      true

  $(document).ajaxError (event, jqXHR, ajaxSettings, thrownError) ->
    wrapped = $("<div>#{jqXHR.responseText}</div>")
    wrapped.find('title').remove()
    wrapped.find('style').remove()
    wrapped.find('head').remove()
    console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
    wrapped.remove()
    true

  true

build_placemark = (item) ->
  new ymaps.GeoObject
    geometry:
      type: 'Point'
      coordinates: [item.latitude, item.longitude]
    properties:
      id: "id_#{item.id}"
      hintContent: item.title
  ,
    cursor: 'help'
    hasBalloon: false
    fillColor: 'ffffff'
    iconImageHref: item.logo.replace(/\/\d+-\d+\//, '/35-35!/')
    iconImageOffset: [-21, -43]
    iconImageSize: [35, 35]
    iconShadow: true
    iconShadowImageHref: '/assets/public/affiche_organization_placemark_bg.png'
    iconShadowImageOffset: [-23, -44]
    iconShadowImageSize: [55, 45]
