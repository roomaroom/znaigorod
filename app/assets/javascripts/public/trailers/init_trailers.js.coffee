@init_trailers = () ->
  trailers = $('.afisha_show .trailer p')

  if trailers.length == 1
    $(trailers).css
      'float': 'none'
      'width': 690
      'height': 437
      'margin-right': 0
    $('iframe', trailers).css
      'width': 690
      'height': 437
    return true

  trailers.each ->
    wrapper = $(this).css('position', 'relative')
    iframe = $('iframe', wrapper)
    overlay = $('<div />').prependTo(wrapper)
    overlay.css
      'position': 'absolute'
      'top': 0
      'left': 0
      'width': wrapper.width()
      'height': wrapper.height()
      'cursor': 'pointer'
    overlay.click ->
      iframe_clone = iframe.clone()
      iframe_clone_src = iframe_clone.attr('src')
      iframe_clone.attr('src', "#{iframe_clone_src}?autoplay=1")
      trailer_dialog = $('<div class="trailer_dialog" />').appendTo('body').html(iframe_clone).hide()
      trailer_dialog.css
        'text-align': 'center'
      $('iframe', trailer_dialog).css
        'width': 740
        'height': 450
        'margin': '0 auto'
      $(trailer_dialog).dialog
        width: 800
        height: 500
        modal: true
        resizable: false
        close: (event, ui) ->
          $(this).parent().remove()
          $(this).remove()
          true
      false
    true
  true
