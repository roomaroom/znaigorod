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

  placemark = new ymaps.GeoObject
    geometry:
      type: 'Point'
      coordinates: [$map.attr('data-latitude'), $map.attr('data-longitude')]
    properties:
      hintContent: $map.attr('data-hint')
  ,
    cursor: 'help'
    hasBalloon: false
    iconImageHref: '/assets/public/balloon.png'
    iconImageSize: [24, 24]
    iconImageOffset: [-16, -25]

  map.geoObjects.add(placemark)

  request_organizations(map, without_organization_id)

  map.events.add 'actionend', (event) ->
    request_organizations(map, without_organization_id)
    true

  $(document).ajaxError (event, jqXHR, ajaxSettings, thrownError) ->
    wrapped = $("<div>#{jqXHR.responseText}</div>")
    wrapped.find('title').remove()
    wrapped.find('style').remove()
    wrapped.find('head').remove()
    console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
    wrapped.remove()

  true

request_organizations = (map, without_organization_id) ->

  a_x = map.getBounds()[0][0]
  a_y = map.getBounds()[0][1]
  b_x = map.getBounds()[1][0]
  b_y = map.getBounds()[1][1]

  console.log without_organization_id

  link = "/organizations/in_bounding_box?location[ax]=#{a_x}&location[ay]=#{a_y}&location[bx]=#{b_x}&location[by]=#{b_y}"
  link += "&without=#{without_organization_id}" if without_organization_id?

  $.ajax
    type: 'GET'
    url: link
    success: (data, textStatus, jqXHR) ->
      console.log data

  true
