@init_font_resizer = ->
  container = $('.opened .description')
  link      = $('a', container)

  $(window).bind('resize', ->
    container_size = container.width()
    text_percentage = 0.06
    text_ratio      = container_size * text_percentage
    text_ems        = text_ratio / 14
    link.css('fontSize', text_ems+'em')
  ).trigger('resize')
