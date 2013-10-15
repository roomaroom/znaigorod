@init_feed_pagination = () ->
  $('.feeds .feed_pagination').css
    'height': '0'
    'visibility': 'hidden'
  list = $(
    '.feeds .feed'
  )
  first_item = $('li:first', list)
  return true unless first_item.length
  if first_item.siblings().length
    last_item = first_item.siblings().last()
  else
    last_item = first_item
  last_item_top = last_item.position().top
  last_item_offset = 200
  page = 1
  busy = false
  $(window).scroll ->
    if ($(this).scrollTop() + $(this).height()) >= (last_item_top - last_item_offset) && !busy
      busy = true
      url = $('.feeds .feed_pagination a').attr('href')
      if url != undefined
        url = url.replace(/^\?/, "&").replace(/&page=\d+/, "")
        $.ajax
          url: url + '&' + 'page=' + (page+1)
          beforeSend: (jqXHR, settings) ->
            $('<li class="ajax_loading_items_indicator">&nbsp;</li>').appendTo(list)
            true
          complete: (jqXHR, textStatus) ->
            $('li.ajax_loading_items_indicator', list).remove()
            true
          success: (data, textStatus, jqXHR) ->
            return true if data.trim().isBlank()
            list.append(data)
            last_item = first_item.siblings().last()
            last_item_top = last_item.position().top
            page += 1
            busy = false unless data.trim().isBlank()
            true
      else
        return true

    true

  true
