@init_filter_resizer = () ->
  $(window).resize(->
    width = 0
    $('.filter.by_date .range .month').each(->
      width += $(this).outerWidth(true)
    ).parent().width(width) .siblings('.range_slider').width(width)
  ).resize()

