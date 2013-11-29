@init_sweets_carousel = ->
  # I have no idea where I have got 4px oO
  carousel = $('#sweets_carousel')
  width = carousel.width()
  count = $('li', carousel).length
  current = 1
  paginator_item = $('.discounts_count .counter')
  classname = 'circle'

  carousel.width( (width + 4) * count )

  move_carousel = (new_current) ->
    nc = new_current.attr('id').match(/[0-9]+/).first()
    carousel.offset({left: (carousel.position().left + ((current - nc) * width) - 4)})
    current = nc

  change_current = (new_current) ->
    $(".selected", paginator_item).removeClass 'selected'
    $(new_current).addClass 'selected'

  paginator = (paginator_item, classname) ->
    count = $('li', carousel).length
    for i in [1..count]
      paginator_item.append("<a id='sweet_#{i}' href='##{i}' class='#{classname}' ></a>")

    change_current '#sweet_1'

    $('a', paginator_item).each (i, val) ->
      $(val).on 'click', () ->

        change_current $(this)
        move_carousel $(this)
        false

  paginator paginator_item, classname





