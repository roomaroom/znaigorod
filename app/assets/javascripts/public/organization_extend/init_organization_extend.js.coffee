@init_organization_jump_to_afisha = ->
  $('.organization_show .afisha_details .presentation_filters .order_by a').click ->
    $.cookie('_znaigorod_jump_to_afisha', true)
    true

  if $.cookie('_znaigorod_jump_to_afisha')
    setTimeout ->
      $.scrollTo $('.organization_show .afisha_details'), 500, { offset: {top: -50} }
      $.removeCookie('_znaigorod_jump_to_afisha')
    , 500

  true

  $('.organization_show .discount_details .presentation_filters .order_by a').click ->
    $.cookie('_znaigorod_jump_to_discounts', true)

  if $.cookie('_znaigorod_jump_to_discounts')
    setTimeout ->
      $.scrollTo $('.organization_show .discount_details'), 500, { offset: {top: -50} }
      $.removeCookie('_znaigorod_jump_to_discounts')
    , 500


@init_organization_show_phone = ->
  $('.js-show-phone').click ->
    target = $(this)
    console.log target
    $.ajax
      url: "/show_phone"
      type: "GET"
      data:
        organization_id: $(target).attr('id')
      success: (response) ->
        $(target).parent().html(response)

      false
    false
  return

@init_organization_list_view_map = ->
  ymaps.ready ->
    $map = $('.map_wrapper .map')
    menu_width = if $('.tree').length then $('.tree').width() else $('.list_view_organization_list').width()
    map = new ymaps.Map $map[0],
      center: [56.4800670145844, 85.00952437484801]
      zoom: 12
      behaviors: ['drag', 'scrollZoom']
      controls: []
    ,
      maxZoom: 23
      minZoom: 11

    map.controls.add 'zoomControl',
      float: 'none'
      position:
        top: 10
        left: menu_width + 20

    clusterer = new ymaps.Clusterer
      clusterDisableClickZoom: true
      showInAlphabeticalOrder: true
      hideIconOnBalloonOpen: false
      groupByCoordinates: true
      clusterBalloonContentLayout: 'cluster#balloonCarousel'
      clusterBalloonPagerType: 'marker'
      clusterBalloonContentLayoutWidth: 192
      clusterBalloonContentLayoutHeight: 355


    $('.list_view_organization_item').each (index, item) ->
      point = new ymaps.GeoObject
        geometry:
          type: 'Point'
          coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]
        properties:
          hintContent: "123"
      ,
        hideIconOnBalloonOpen: false

      clusterer.add point

      true

    map.geoObjects.add clusterer

    $('.list_view_organization_posters').on 'ajax:success', '.pagination', (evt, response) ->
      $(response).filter('.list_view_organization_item').each (index, item) ->
        point = new ymaps.GeoObject
          geometry:
            type: 'Point'
            coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]
          properties:
            hintContent: "123"
        ,
          hideIconOnBalloonOpen: false

        clusterer.add point

      map.geoObjects.add clusterer

      true

    $('.js-open-list').click ->
      $(this).parent().next('.categories').toggle()
      $(this).toggleClass('minus plus')
      false

    $('.js-swap-position').click ->
      $(this).parent().toggleClass('left_position right_position')
      $(this).parent().css('left','').css('right','10px')
      $(this).toggleClass('swap_left swap_right')
      $(this).parent().find('.js-resize').toggleClass('left right')

      zoom_position = if $(this).is('.swap_left') then $(this).parent().width() + 20 else 1150 - $(this).parent().width()
      map.controls.remove 'zoomControl'
      map.controls.add 'zoomControl',
        float: 'none'
        position:
          top: 10
          left: zoom_position

      false

    $('.js-resizable').resizable({
      handles: "w, e"
      minWidth: 300
      maxWidth: 490
      resize: (event, ui) ->
        target = ui.element
        zoom_position = if $('.swap_left').length then ui.size.width + 20 else 1150 - ui.size.width
        map.controls.remove 'zoomControl'
        map.controls.add 'zoomControl',
          float: 'none'
          position:
            top: 10
            left: zoom_position

        if ui.size.width > 449
          target.addClass('maximum').removeClass('medium small')

        if ui.size.width <= 449 && ui.size.width > 320
          target.addClass('medium').removeClass('maximum small')

        if ui.size.width <= 320
          target.addClass('small').removeClass('medium')
    })
