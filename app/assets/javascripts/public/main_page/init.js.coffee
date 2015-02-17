@init_main_page_reviews = () ->

  wrapper = $('.reviews_main_page')
  toggler = $('.reviews_toggler', wrapper)
  interval = 5000
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

  $('.right_arrow', wrapper).click ->
    selected = $('.reviews_toggler img.selected', wrapper)
    if selected.closest('li').is(':last-child')
      $('img', selected.closest('li').siblings().first()).click()
    else
      $('img', selected.closest('li').next()).click()
    return

  $('.left_arrow', wrapper).click ->
    selected = $('.reviews_toggler img.selected', wrapper)
    if selected.closest('li').is(':first-child')
      $('img', selected.closest('li').siblings().last()).click()
    else
      $('img', selected.closest('li').prev()).click()
      return

  return
