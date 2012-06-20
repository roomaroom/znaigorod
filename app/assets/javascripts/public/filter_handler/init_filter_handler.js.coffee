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

      when 'by_affiche_category'
        $.extend params, get_params_from_checker(context, 'affiche_category')
        break

      when 'by_categories'
        $.extend params, get_params_from_checker(context, 'categories')
        break

      when 'by_tag'
        $.extend params, get_params_from_checker(context, 'tags')
        break

      when 'by_cuisine'
        $.extend params, get_params_from_checker(context, 'cuisine')
        break

      when 'by_payment'
        $.extend params, get_params_from_checker(context, 'payment')
        break

      when 'by_feature'
        $.extend params, get_params_from_checker(context, 'feature')
        break

      when 'by_offer'
        $.extend params, get_params_from_checker(context, 'offer')
        break

  { utf8: true, search: params }

@init_filter_handler = () ->
  filters = $('.filters')
  url = '/'+filters.attr('id')

  search_preset = window.location.hash.replace('#','')

  filters.on 'changed', ->
    list_block =  $('.list')

    list_block.addClass('filled')

    list_block.animate({opacity: 0}, 900, ->
      list_block.addClass('preloader').html('<img src="/assets/preloader.gif" width=48 height=48 style="margin: 0 auto; display: block" />').animate({opacity: 1}, 900, ->
        $.ajax
          url: url
          type: 'GET'
          data: filters.prepare_params()
          success: (data, textStatus, jqXHR) ->
            list_block.removeClass('preloader').animate({opacity: 0}, 900, ->
              list_block.addClass('filled').html(jqXHR.responseText).animate({opacity: 1}, 900)
              init_tablesorter()
              init_remote_pagination()
            )
      ) unless list_block.hasClass('preloader')
    ).removeClass('filled') if list_block.hasClass('filled')

  if search_preset.length && filters.length
    window.location.hash = ''

    if search_preset == 'todays'
      hour = new Date().getHours()
      $('#by_date').slider('values', [0,1])
      $('#by_time').slider('values', [hour, 24])
      $('.by_time h6 a').click()
      return false

    if search_preset.length
      $('h6 a', $('.' + search_preset).closest('.filter')).click()
      $('.' + search_preset).click()
      return false
