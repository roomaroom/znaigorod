@init_afisha_extend = () ->
  if window.location.hash == '#photogallery' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.afisha_show .photogallery'), 500, { offset: {top: -50} })
      true
    , 300
  if window.location.hash == '#trailer' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.afisha_show .trailer'), 500, { offset: {top: -60} })
      true
    , 300
  true


window_scroll_init = (state) ->

  $('body .pagination').css
    'height': '0'
    'visibility': 'hidden'
  busy = false

  item = $("#events_filter ##{state} .afisha_list .posters")
  first_item = $('li:first', item)
  return true unless first_item.length
  if first_item.siblings().length
    last_item = first_item.siblings().last()
  else
    last_item = first_item
  last_item_top = last_item.position().top

  last_item_offset = 400


  $(window).scroll ->

    if ($(this).scrollTop() + $(this).height()) >= (last_item_top - last_item_offset) && !busy
      busy = true
      a = $("##{state} .pagination a")
      url = a.attr('href')
      if url != undefined
        a.parent().remove()

        $.ajax
          url: url
          beforeSend: (jqXHR, settings) ->
            $('<li class="ajax_loading_items_indicator">&nbsp;</li>').appendTo(item)
            true
          complete: (jqXHR, textStatus) ->
            $('li.ajax_loading_items_indicator', item).remove()
            true
          success: (data, textStatus, jqXHR) ->
            return if  $(data).children().length == 1
            $("##{state} .afisha_list .posters").append(data)

            account_afisha_remove()

            $("##{state} .pagination").css
              'height': '0'
              'visibility': 'hidden'

            busy = false
            true

    true

@init_afisha_tabs = () ->
  $('#events_filter').tabs()
  window_scroll_init('all')
  $('#events_filter').on "tabsselect", (event, ui) ->
    $(window).unbind('scroll')
    window_scroll_init(ui.panel.id)
