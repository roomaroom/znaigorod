@init_affiche_yandex_map = () ->

  ymaps.ready ->

    $map = $('.yandex_map .map')

    map = new ymaps.Map $map[0],
      center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
      zoom: 15
      behaviors: []

    map.cursors.push('pointer')

    map.events.add 'click', (event) ->
      init_modal_affiche_yandex_map($map)
      yaCounter14923525.reachGoal('affiche_map_click') if yaCounter14923525?
      true

    magnifier_layout = ymaps.templateLayoutFactory.createClass("<div class='magnifier_button'></div>")

    magnifier_button = new ymaps.control.Button
      data:
        title: 'Нажмите для увеличения карты'
    ,
      layout: magnifier_layout
      position:
        left: 5
        top: 5
      selectOnClick: false

    magnifier_button.events.add 'click', (event) ->
      yaCounter14923525.reachGoal('affiche_magnifier_click') if yaCounter14923525?
      init_modal_affiche_yandex_map($map)
      true

    map.controls.add(magnifier_button)

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
      iconImageOffset: [-15, -40]
      iconImageSize: [37, 42]
      zIndex: 1000
      zIndexHover: 1100

    map.geoObjects.add(affiche_placemark)

    true

  true

@init_modal_affiche_yandex_map = (data_block) ->

  dialog_width = $(window).innerWidth() * 70 / 100
  dialog_height = $(window).innerHeight() * 90 /100

  ymaps.ready ->

    $('<div id=\'modal_affiche_yandex_map\'></div>').dialog
      width: dialog_width
      height: dialog_height
      modal: true
      resizable: false
      open: (event, ui) ->
        $map = $(this)

        $map.attr('data-latitude', data_block.attr('data-latitude'))
        $map.attr('data-longitude', data_block.attr('data-longitude'))
        $map.attr('data-hint', data_block.attr('data-hint'))
        $map.attr('data-id', data_block.attr('data-id'))

        map = new ymaps.Map this,
          center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
          zoom: 16
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
          iconImageHref: '/assets/public/affiche_placemark.png'
          iconImageOffset: [-15, -40]
          iconImageSize: [37, 42]
          zIndex: 700

        if $map.attr('data-id')?
          affiche_placemark.events.add 'click', (event) ->
            return false if affiche_placemark.options.get('freeze')
            affiche_placemark.options.set('freeze', true)
            $.ajax
              method: 'GET'
              url: "/organizations/#{$map.attr('data-id')}/details_for_balloon"
              crossDomain: true
              success: (data, textStatus, jqXHR) ->
                item = data
                affiche_placemark.properties.set
                  balloonContentHeader: item.title
                  balloonContent: generate_item_description(item)
                affiche_placemark.options.set
                  hasBalloon: true
                affiche_placemark.balloon.open()
                true
            true
        else
          affiche_placemark.options.set
            cursor: 'help'
            hasBalloon: false

        map.geoObjects.add(affiche_placemark)

        map.controls.add 'zoomControl',
          top: 5
          left: 5

        render_organizations(map, $map.attr('data-id'))

        map.events.add 'actionend', (event) ->
          render_organizations(map, $map.attr('data-id'))
          true

        $('.organization_description .link a, .organization_description .image a').live 'click', (event) ->
          window.location.href = $(this).attr('href')
          false

        true

      close: (event, ui) ->
        $(this).parent().remove()
        $(this).remove()
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
    crossDomain: true
    success: (data, textStatus, jqXHR) ->
      builded_placemarks = {}
      builded_placemark_ids = []
      freezed_placemarks = {}
      need_delete_placemarks = []

      $.each data, (index, item) ->
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

  true

build_placemark = (item) ->

  switch item.suborganization
    when 'billiard'         then item_preset = 'twirl#darkgreenDotIcon'
    when 'car_sales_center' then item_preset = 'twirl#darkblueDotIcon'
    when 'car_wash'         then item_preset = 'twirl#blueDotIcon'
    when 'creation'         then item_preset = 'twirl#greenDotIcon'
    when 'culture'          then item_preset = 'twirl#greyDotIcon'
    when 'entertainment'    then item_preset = 'twirl#blackDotIcon'
    when 'meal'             then item_preset = 'twirl#darkorangeDotIcon'
    when 'salon_center'     then item_preset = 'twirl#yellowDotIcon'
    when 'sauna'            then item_preset = 'twirl#orangeDotIcon'
    when 'sport'            then item_preset = 'twirl#nightDotIcon'

  point = new ymaps.GeoObject
    geometry:
      type: 'Point'
      coordinates: [item.latitude, item.longitude]
    properties:
      id: "id_#{item.id}"
      hintContent: item.title
  ,
    hasBalloon: true
    preset: item_preset

  point.events.add 'click', (event) ->
    return false if point.options.get('freeze')
    point.options.set('freeze', true)
    $.ajax
      method: 'GET'
      url: "/organizations/#{item.id}/details_for_balloon"
      crossDomain: true
      success: (data, textStatus, jqXHR) ->
        item = data
        point.properties.set
          balloonContentHeader: item.title
          balloonContent: generate_item_description(item)
        point.balloon.open()
        true
    true

  point

generate_item_description = (item) ->
  item_description = "" +
    "<div class='organization_description'>" +
    "<div class='image'>" +
    "<a href='#{item.url}'>" +
    "<img alt='#{item.title}' title='#{item.title}' src='#{item.logo.replace(/\/\d+-\d+\//, '/60-60!/')}' width='60' height='60' />" +
    "</a>" +
    "</div>" +
    "<div class='clearfix'>"
    "<p class='address'>#{item.address}</p>"
  item_description += item.phones if item.phones?
  item_description += item.schedule_today
  item_description += "" +
     "<p class='link'><a href='#{item.url}'>страница организации</a></p>" +
     "</div>"
     "</div>"

  item_description
