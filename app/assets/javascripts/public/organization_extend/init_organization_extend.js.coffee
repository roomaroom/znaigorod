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

  true


@init_organization_show_phone = ->
  $('.js-show-phone').click ->
    target = $(this)
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
    $map = $('.suborganizations_map_wrapper .map')
    menu_width = if $('.tree').length then $('.tree').width() else $('.list_view_organization_list').width()
    map = new ymaps.Map $map[0],
      center: [56.4800670145844, 84.95244759591]
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
      clusterBalloonContentLayoutWidth: 210
      clusterBalloonContentLayoutHeight: 240


    $('.list_view_organization_item').each (index, item) ->
      link = $('.info h1 a', item)
      title = link.text()
      point = new ymaps.GeoObject
        geometry:
          type: 'Point'
          coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]
        properties:
          balloonContentBody: "" +
            "<div class='ymaps-2-1-17-b-cluster-content__body'>" +
            "<a href='#{link.attr('href')}' target='_blank'>" +
            "<img width='190' height='190' src='#{$(item).attr('data-image')}' />" +
            "</a>" +
            "<div class='balloon_content_header' style='margin:5px 0;padding-bottom:5px;width:190px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>" +
            "<a href='#{link.attr('href')}' target='_blank' title='#{title}'>#{title}</a>" +
            "</div>"
          hintContent: title
          id: $(item).attr('data-slug')
      ,
        hideIconOnBalloonOpen: false
        iconLayout: 'default#image'
        iconImageHref: $(item).attr('data-icon')
        iconImageSize: [35, 50]
        iconImageOffset: [-18, -18]

      clusterer.add point

      true

    map.geoObjects.add clusterer

    $('.list_view_organization_posters').on 'ajax:success', '.pagination', (evt, response) ->
      $(response).filter('.list_view_organization_item').each (index, item) ->
        link = $('.info h1 a', item)
        title = link.text()
        point = new ymaps.GeoObject
          geometry:
            type: 'Point'
            coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]
          properties:
            balloonContentBody: "" +
              "<div class='ymaps-2-1-17-b-cluster-content__body'>" +
              "<a href='#{link.attr('href')}' target='_blank'>" +
              "<img width='190' height='190' src='#{$(item).attr('data-image')}' />" +
              "</a>" +
              "<div class='balloon_content_header' style='margin:5px 0;padding-bottom:5px;width:190px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>" +
              "<a href='#{link.attr('href')}' target='_blank' title='#{title}'>#{title}</a>" +
              "</div>"
            hintContent: title
        ,
          hideIconOnBalloonOpen: false
          preset: 'islands#circleDotIcon'
          iconColor: '#1E98FF'
          iconWidth: '5'
          iconHeight: '5'

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

    $('.js-organization-item').each (index, item) ->
      $(item).hover (e) ->
        init_hl_icons_on_map($(this), 'h', clusterer)
      , (e) ->
        init_hl_icons_on_map($(this), 'n', clusterer)

      true

    $('.js-resizable').resizable({
      handles: "w, e"
      minWidth: 300
      maxWidth: 490
      minHeight: 598
      maxHeight: 628
      resize: (event, ui) ->
        target = ui.element
        target.css('height', 'auto')
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
    true

@init_focus_for_search_button = () ->
  $('.js-search-field').focusin ->
    $('.js-search-button').toggleClass('selected')

  $('.js-search-field').focusout ->
    $('.js-search-button').toggleClass('selected')

# state, h - highlight
# state, n - not highlight
init_hl_icons_on_map = (target, state = 'h', clusterer) ->
  objects = clusterer.getGeoObjects()
  objects.each (index, value) ->
    slug = index.properties.get('id')
    if $(target).attr('data-slug') == slug
      if state == 'n'
        index.options.set('preset', 'islands#blueIcon')
        index.options.set('zIndex', 100)
      else
        index.options.set('preset', 'islands#pinkIcon')
        index.options.set('zIndex', 1000)

  true
