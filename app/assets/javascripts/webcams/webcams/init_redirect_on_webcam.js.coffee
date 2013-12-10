@init_redirect_on_webcam = () ->
  $('.webcams .redirect_to').click ->
    return true if $(this).closest('.content_wrapper').length
    window.opener.location.href = $(this).attr('href')
    self.close()
    false

  true
