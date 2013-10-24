@init_accounts_for_lottery = () ->

  $('.accounts_for_lottery .toggable').click ->
    if $(this).hasClass('down')
      $(this).removeClass('down').addClass('up')
      $('.accounts_for_lottery .value').show()
    else
      $(this).removeClass('up').addClass('down')
      $('.accounts_for_lottery .value').hide()
    false

  true
