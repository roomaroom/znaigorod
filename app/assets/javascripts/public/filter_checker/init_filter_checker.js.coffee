@init_filter_checker = () ->
  filters = $('.filters')

  $('.by_category li a, .by_tag li a').click ->
    $(this).toggleClass('active')
    filters.trigger('changed')

    false
