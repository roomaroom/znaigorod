@init_photogallery = () ->

  $('#photogallery_og_image').on 'change', ->
    $(this).parents('form').submit()
    true

  true
