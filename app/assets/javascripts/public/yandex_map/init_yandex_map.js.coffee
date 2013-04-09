@init_affiche_yandex_map = () ->
  $map = $('.yandex_map .map')

  without_organization_id = $map.attr('data-without-id')

  map = new ymaps.Map $map[0],
    center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
    zoom: 15
    behaviors: 'drag'

  map.controls.add 'smallZoomControl',
    right: 5
    top: 5

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

  map.geoObjects.add(affiche_placemark)

  #request_organizations(map, affiche_placemark, without_organization_id)

  map.events.add 'actionend', (event) ->
    #request_organizations(map, affiche_placemark, without_organization_id)
    true

  $(document).ajaxError (event, jqXHR, ajaxSettings, thrownError) ->
    wrapped = $("<div>#{jqXHR.responseText}</div>")
    wrapped.find('title').remove()
    wrapped.find('style').remove()
    wrapped.find('head').remove()
    console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
    wrapped.remove()

  true

request_organizations = (map, affiche_placemark, without_organization_id) ->

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
      map.geoObjects
      $.each data, (index, item) ->
        true
      true

  true
