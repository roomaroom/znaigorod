@init_schedule_toggle = () ->
  schedule = $(".organization_info .more_schedule")
  schedule.each (index, item) ->
    $('<li class=\'arrow_wrapper\'><span class=\'arrow\'></span></li>').prependTo($(item))
    link = $('.show_more_schedule', $(item).prev('.work_schedule'))
    return true unless link.position()
    $(item).css
      'top': link.position().top + link.outerHeight(true, true) + 8
      'left': link.position().left
      'z-index': 99999
    link.addClass('clickable').click () ->
      $(item).removeClass('visible').toggle()
      setTimeout ->
        $(item).addClass('visible')
      , 1
      true
    true
  true

  $(document).click ->
    $(".organization_info .more_schedule.visible").removeClass('visible').hide()
