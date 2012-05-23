get_params_from_slider = (context, min_key, max_key) ->
  params = {}
  slider = $('#'+context)
  slider_parent = slider.parent()
  min = slider.slider('values', 0)
  max = slider.slider('values', 1) - 1
  min_value =  slider_parent.find('.item_'+min).attr('data-value')
  max_value =  slider_parent.find('.item_'+max).attr('data-value')
  params[min_key] = min_value
  params[max_key] = max_value

  params

get_params_from_checker = (context, key) ->
  params = {}

  buf = []
  $('.'+context+' ul .active').each ->
    buf.push $(this).attr('data-value')
  params[key] = buf

  params

$.fn.prepare_params = () ->
  $this = $(this)
  params = {}

  $this.find('.filter').each ->
    context = $(this).attr('class').replace('filter ', '')

    switch context
      when 'by_date'
        $.extend params, get_params_from_slider(context, 'starts_on_gt', 'starts_on_lt')
        break

      when 'by_time'
        $.extend params, get_params_from_slider(context, 'starts_at_hour_gt', 'starts_at_hour_lt')
        break

      when 'by_amount'
        $.extend params, get_params_from_slider(context, 'price_gt', 'price_lt')
        break

      when 'by_category'
        $.extend params, get_params_from_checker(context, 'categories')
        break

      #when 'by_tag'
        #$.extend params, get_params_from_checker(context, 'tags')
        #break

  { utf8: true, search: params }

send_request = (params) ->
  $.ajax
    url: '/affiches'
    type: 'GET'
    data: params
    success: (data, textStatus, jqXHR) ->
      $('.list').html(jqXHR.responseText)
      init_tablesorter()


@init_filter_handler = () ->
  filters = $('.filters')
  filters.on 'changed', ->
    setTimeout( ->
      send_request(filters.prepare_params())
    , 1500)
