@initMyDiscount = ->
  $('.js-toggle-forms').click ->
    $('.relations').toggle()
    $('.organization_wrapper').toggle()


  $('#discount_sale').change ->
    if $('#discount_discount:enabled').length
      $('#discount_discount').prop('disabled', true)
      $('.select_type').prop('disabled', true)
    else
      $('#discount_discount').prop('disabled', false)
      $('.select_type').prop('disabled', false)


  $('#discount_constant').change ->
    if $('#discount_ends_at:enabled').length
      $('#discount_ends_at').prop('disabled', true)
      $('#discount_starts_at').prop('disabled', true)
    else
      $('#discount_ends_at').prop('disabled', false)
      $('#discount_starts_at').prop('disabled', false)

  $('.examples').click ->
    $('.help_examples').show()
