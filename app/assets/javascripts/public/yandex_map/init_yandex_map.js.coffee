@init_affiche_yandex_map = () ->
  $map = $('.yandex_map .map')

  map = new ymaps.Map $map[0],
    center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
    zoom: 15
    behaviors: ['drag', 'scrollZoom']

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

  true
