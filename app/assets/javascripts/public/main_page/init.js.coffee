@init_main_page_reviews_toggler = () ->

  wrapper = $('.reviews_main_page')
  toggler = $('.reviews_toggler', wrapper)
  interval = 5000
  timer = null

  $('img', toggler).on 'click', ->
    return if $(this).hasClass('selected')
    $('.reviews li:visible', wrapper).fadeOut()
    $(".reviews .#{$(this).attr('class')}", wrapper).fadeIn()
    $('img', $(this).closest('li').siblings()).removeClass('selected')
    $(this).addClass('selected')

    return

  calculate_and_click_toggle = ->
    if $('.selected', toggler).closest('li').is(':last-child')
      $('li:first img', toggler).click()
    else
      $('img', $('.selected', toggler).closest('li').next()).click()

    return

  $(wrapper).on 'mouseenter', ->
    clearInterval(timer)
    timer = null

    return

  $(wrapper).on 'mouseleave', ->
    timer = setInterval ->
      calculate_and_click_toggle()
    , interval

    return

  timer = setInterval ->
    calculate_and_click_toggle()
  , interval

  return

@init_main_page_reviews_carousel = () ->

  wrapper = $('.reviews_main_page')
  carousel = $('.reviews_carousel', wrapper)
  li_width = $('li', carousel).outerWidth(true, true)
  interval = 10000
  timer = null

  reorder_and_slide_carousel = (clicked_img) ->
    $('ul', carousel).stop(true, true)
    if clicked_img.closest('li').index() < $('img.selected', carousel).closest('li').index()
      $('ul', carousel).css('left', "-#{li_width}px")
      $('ul', carousel).prepend($('ul li:last', carousel))
      $('ul', carousel).animate
        'left': "+=#{li_width}px"
    else
      $('ul', carousel).animate
        'left': "-=#{li_width}px"
      , ->
        $('ul', carousel).append($('ul li:first', carousel))
        $('ul', carousel).css('left', 0)
        return

    $('img', carousel).removeClass('selected')
    clicked_img.addClass('selected')

    return

  $('.reviews_carousel img', wrapper).on 'click', ->
    return if $(this).hasClass('selected')
    $('.reviews li:visible', wrapper).fadeOut()
    $(".reviews .#{$(this).attr('class')}", wrapper).fadeIn()
    reorder_and_slide_carousel($(this))

    return

  $('.left_arrow', carousel).click ->
    $('img', $('img.selected', carousel).closest('li').prev()).click()
    return

  $('.right_arrow', carousel).click ->
    $('img', $('img.selected', carousel).closest('li').next()).click()
    return

  $(wrapper).on 'mouseenter', ->
    clearInterval(timer)
    timer = null

  $(wrapper).on 'mouseleave', ->
    timer = setInterval ->
      $('img', $('img.selected', carousel).closest('li').next()).click()
    , interval

    return

  timer = setInterval ->
    $('img', $('img.selected', carousel).closest('li').next()).click()
  , interval

  return
