@init_sweets_carousel = ->

  # config

  # the carousel container
  carousel = $('#sweets_carousel')
  # the paginator config
  paginator_parent = $('.discounts_count') # this is the paginator container
  paginator_item = $('.discounts_count .counter') # this is the paginator items container
  classname = 'circle' # this is a class name of paginator item
  # the arrows config
  next_arrow = $("#Next")
  previous_arrow = $("#Previous")
  # the animation config
  animation_type = 'fadeToggle'
  animation_speed = 400
  can_scroll_through = true
  # the timer of paginator config
  interval = 15000
  enabletimer = true
  mouse_over_stop = true

  # end of config

  timer = 0
  busy = false
  width = carousel.width()
  count = $('li', carousel).length
  current = 1

  carousel.width((width) * count)

  move_by_timer = () ->
    next_arrow.click()

  get_paginator_item = (num) ->
    $("#sweet_#{num}", paginator_item)

  move_carousel = (new_current) ->
    nc = new_current.attr('id').match(/[0-9]+/).first()
    offset = (carousel.css('margin-left').toNumber() + ((current - nc) * width))

    unless can_scroll_through
      activate_all()
      change_activity($(next_arrow)) if nc*1 == count
      change_activity($(previous_arrow)) if nc*1 == 1

    if animation_type == 'fadeToggle'
      carousel.fadeOut((animation_speed / 2),
                        () ->
                          $(this).css('margin-left', offset)
                      )
              .fadeIn(
                (animation_speed / 2),
                () ->
                  change_current(new_current)
                  current = nc*1
                  busy = false
              )

    else
      carousel.animate(
        {marginLeft: offset},
        animation_speed,
        () ->
          change_current(new_current)
          current = nc*1
          busy = false
      )

  change_current = (new_current) ->
    $(".selected", paginator_item).removeClass 'selected'
    $(new_current).addClass 'selected'
    true

  change_activity = (arrow) ->
    arrow.removeClass 'active'
    arrow.addClass 'inactive'
    true

  activate_all = () ->
    $(next_arrow).addClass 'active'
    $(next_arrow).removeClass 'inactive'
    $(previous_arrow).addClass 'active'
    $(previous_arrow).removeClass 'inactive'


  paginator = (paginator_item, classname) ->
    count = $('li', carousel).length
    for i in [1..count]
      paginator_item.append("<a id='sweet_#{i}' href='##{i}' class='#{classname}' ></a>")

    change_current '#sweet_1'

    $('a', paginator_item).each (i, val) ->
      $(val).on 'click', (e) ->
        e.preventDefault()
        unless busy
          timerStop()
          timerStart()
          busy = true
          move_carousel $(this)

  next_arrow.on 'click', (e) ->
    e.preventDefault()
    unless busy || next_arrow.hasClass('inactive')
      busy = true
      timerStop()
      timerStart()
      if current == count
        move_carousel get_paginator_item(1)
      else
        move_carousel get_paginator_item(current + 1)

  previous_arrow.on 'click', (e) ->
    e.preventDefault()
    unless busy || previous_arrow.hasClass('inactive')
      busy = true
      timerStop()
      timerStart()
      if current == 1
        move_carousel get_paginator_item(count)
      else
        move_carousel get_paginator_item(current - 1)

  if previous_arrow.length && !can_scroll_through
    change_activity($(previous_arrow))


  timerStart = () ->
    if enabletimer
      timer = setInterval(move_by_timer, interval)

  timerStop = () ->
    if enabletimer
      clearInterval(timer)

  carousel.add(previous_arrow).add(next_arrow).add(paginator_parent).mouseout () ->
    if mouse_over_stop
      timerStart()
      true

  carousel.add(previous_arrow).add(next_arrow).add(paginator_parent).mouseover () ->
    if mouse_over_stop
      timerStop()
      true

  timerStart()

  paginator paginator_item, classname

  true
