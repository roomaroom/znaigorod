@init_main_page_reviews = () ->

  wrapper = $('.reviews_main_page')
  toggler = $('.reviews_toggler', wrapper)
  interval = 10000
  timer = null

  $('.reviews_toggler img', wrapper).on 'click', ->
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
