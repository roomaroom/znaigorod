@init_organization = ->
  $('.js-open-list').click ->
    $(this).parent().next('.categories').toggle()
    $(this).toggleClass('minus plus')
    false

  $('.js-swap-position').click ->
    $(this).parent().toggleClass('left_tree right_tree')
    $(this).toggleClass('swap_left swap_right')
    false

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

  $('.js-show-phone').click ->
    $.ajax
      url: "/show_phone"
      type: "GET"
      data:
        organization_id: $(this).attr('id')
      success: (response) ->
        $('.phone_wrapper').empty()
        $('.phone_wrapper').append(response)
      done:
        $(this).remove()

@init_organization_list_view_map = ->
  ymaps.ready ->
    $map = $('.map_wrapper .map')
    map = new ymaps.Map $map[0],
      center: [56.4800670145844, 85.00952437484801]
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

    clusterer = new ymaps.Clusterer
      clusterDisableClickZoom: true
      showInAlphabeticalOrder: true
      hideIconOnBalloonOpen: false
      groupByCoordinates: true
      clusterBalloonContentLayout: 'cluster#balloonCarousel'
      clusterBalloonPagerType: 'marker'
      clusterBalloonContentLayoutWidth: 192
      clusterBalloonContentLayoutHeight: 355
      clusterIconContentLayout: null

    $('.list_view_organization_item').each (index, item) ->
      point = new ymaps.GeoObject
        geometry:
          type: 'Point'
          coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]

      clusterer.add point

    map.geoObjects.add clusterer

@init_resizable_list = ->
  $('.js-resizable').resizable({
    handles: "w, e"
    minWidth: 300
    maxWidth: 490
    grid: [95, 0]
    resize: (event, ui) ->
      target = ui.element
      console.log ui.size

      if ui.size.width > 449
        target.addClass('maximum').removeClass('medium small')

      if ui.size.width <= 449 && ui.size.width > 300
        target.addClass('medium').removeClass('maximum small')

      if ui.size.width == 300
        target.addClass('small').removeClass('medium')
  })
