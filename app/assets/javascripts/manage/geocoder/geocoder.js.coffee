$.fn.get_object = ->
  form_data = this.serializeArray()
  form_object = {}
  $(form_data).each (i, item) ->
    form_object[item.name] = item.value
  form_object

$.fn.draw_map = (organization) ->
  container = this[0]
  point = new DG.GeoPoint(organization['eating[address_attributes][longitude]'], organization['eating[address_attributes][latitude]'])
  map = new DG.Map(container)
  marker = new DG.Markers.Common({ geoPoint: point })
  scale = organization['scale'] || 15
  DG.autoload ->
    map.controls.add(new DG.Controls.Zoom())
  map.setCenter(point, scale)
  map.markers.add(marker)

update_coordinates = (organization) ->
  $.ajax '/manage/geocoder',
    async:    false
    dataType: 'json'
    data:     'street='+organization['eating[address_attributes][street]']+'&house='+organization['eating[address_attributes][house]']
    error: (jqXHR, textStatus, errorThrown) ->
      console.log(errorThrown)

    success: (data, textStatus, jqXHR) ->
      json = jQuery.parseJSON jqXHR.responseText
      organization['eating[address_attributes][longitude]'] = json.longitude
      organization['eating[address_attributes][latitude]']  = json.latitude
      organization['scale'] = json.scale
      $('#eating_address_attributes_longitude').val(json.longitude)
      $('#eating_address_attributes_latitude').val(json.latitude)

$.fn.handler = (form, map_container) ->
  this.click ->
    organization = form.get_object()
    update_coordinates(organization)
    map_container.draw_map(organization)
    false

$ ->
  form = $('form.eating')
  if form.length
    organization = form.get_object()
    map_container = $('#map')
    update_coordinates(organization)
    map_container.draw_map(organization)
    $('.get_coordinates').handler(form, map_container)
