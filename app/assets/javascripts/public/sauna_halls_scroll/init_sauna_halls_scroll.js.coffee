@init_sauna_halls_scroll = () ->

  $('.organizations_list .need_scrolling').jScrollPane
     verticalGutter: 2
     showArrows: true
     mouseWheelSpeed: 30

  $('.organizations_list .need_scrolling').each (index, item) ->
    return true unless $('li.non_suitable', $(this)).length
    $('li.non_suitable', $(this)).appendTo($('li.non_suitable:first', $(this)).parent())
    true

  true
