@init_filter_resizer = () ->
  $(window).resize(->
    filters_width = $('.filters').width() - 34
    $('.by_date').width filters_width

    reset_width = $('.by_time .span1').outerWidth(true)
    $('.by_time span11, .by_time .pod_wrapper').width filters_width - reset_width

    second_wrapper_width = 0
    $('.by_date .second_wrapper .month').each(->
      second_wrapper_width += $(this).outerWidth(true)
    ).parent().width second_wrapper_width

  ).resize()

