@init_affix = () ->
  sidebar = $('.js-sidebar')
  $(window).scroll (e) ->
    scrollTop = $(this).scrollTop()
    if scrollTop < sidebar.position().top
      sidebar.removeClass('fixed')
    else
      sidebar.addClass('fixed')
    return
