@init_filter_collapser = () ->

  $('.filter h6 a').click ->
    $(this).parent().toggleClass('open').next('.filter_wrapper').slideToggle()

    false
