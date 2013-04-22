@init_services = () ->
  $('.services .info h3 a').live 'click', ->
    link = $(this)
    link.toggleClass('opened').toggleClass('closed')
    $('.details', link.closest('.info')).slideToggle('fast')
    false
