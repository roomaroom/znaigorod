@init_has_virtual_tour = () ->
  add_link = $('.add_vitual_tour')
  remove_link = $('.remove_virtual_tour')

  $('.virtual_tour_fields').on 'nested:fieldAdded', ->
    add_link.hide()
    remove_link.show()

  $('.virtual_tour_fields').on 'nested:fieldRemoved', ->
    add_link.show()
    remove_link.hide()

  add_link.hide()
