@init_move_to_top = () ->
  link = $("a.move_to_top")

  barrier = link.prev(".affiches_filter").outerHeight(true, true) + 100

  link.css
    top: $(window).height() / 2 - link.outerHeight() / 2
    left: link.prev().position().left + link.prev().outerWidth() / 2 - link.outerWidth() / 2 + 20

  $(window).resize ->
    link.css
      top: $(window).height() / 2 - link.outerHeight() / 2
      left: link.prev().position().left + link.prev().outerWidth() / 2 - link.outerWidth() / 2 + 20

  $(window).scroll ->
    if link.is(":hidden") && $(this).scrollTop() > barrier
      link.fadeIn()
    if link.is(":visible") && $(this).scrollTop() < barrier
      link.fadeOut()

  link.click (event) ->
    if $.scrollTo
      $.scrollTo '.header_wrapper', 100,
        easing: 'easeOutExpo'
    else
      window.scrollTo(0, 0)
    false
  true
