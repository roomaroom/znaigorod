@init_organization_info = () ->
  block = $('.organization_info .info .description')
  block_height = block.height()
  if block.height() > 24
    block.height(24)
    $('<a href=\'#\' class=\'toggler closed\'>развернуть</a>').prependTo(block)
  $('a.toggler', block).click (event) ->
    $(this).toggleClass('closed').toggleClass('opened')
    if $(this).hasClass('opened')
      $(this).text('свернуть')
      block.stop(true, true).animate
        height: block_height
      , 'fast'
    if $(this).hasClass('closed')
      $(this).text('развернуть')
      block.stop(true, true).animate
        height: 24
      , 'fast'
    false
  true
