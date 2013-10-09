@init_show_tipsy = () ->
  $('.show_tipsy').tipsy
    gravity: $.fn.tipsy.autoNS
    html: true
    live: true
    offset: 10
    opacity: 1

  true
