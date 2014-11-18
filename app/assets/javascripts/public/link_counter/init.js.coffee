@init_banner_stat = ->
  $('.js-banner a').click ->
    link = $(this).attr('href')
    name = $(event.target).attr('alt')
    console.log name
    perform_ajax(link, name, 'banner')

@init_right_block_stat = ->
  $('.promotions').on 'click', $('.js-right-block a'), ->
    if $('.js-right-block a').length

      element = $(event.target)
      if element.get(0).tagName == 'IMG'
        link = element.parent().attr('href')
      else
        link = element.attr('href')

      name = element.text()
      perform_ajax(link, name, 'right')

perform_ajax = (link, name, type) ->
  $.ajax
    type: 'get'
    url: '/link_counters/create'
    data: {
      link_type: type,
      name: name,
      link: link
    }
