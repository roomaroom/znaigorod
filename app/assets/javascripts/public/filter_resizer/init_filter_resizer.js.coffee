@init_filter_resizer = () ->

  $(window).resize(->
    $('.by_date').width($('.filters').width())
  ).resize()
