@initMyDiscount = ->
  init_discount_switch() if $('.switch_box').length

  $('.js-toggle-forms').click ->
    $('.organization_wrapper').toggle('slow')

    false

  $('.js-examples').click ->
    $('.help_examples').show()

    false

init_discount_switch = () ->
  $('.switch_box').on 'change', ->

    if $(this).parent().closest('.period').length
      wrapper = $(this).parent().closest('.period')
    else
      wrapper = $(this).parent().closest('.discount_type')

    input = $('input[type="text"]', wrapper)
    input_numeric = $('input[type="number"]', wrapper)
    select = $('select', wrapper)


    if $(this).is(':checked')
      input.prop('disabled', true)
      input_numeric.prop('disabled', true)
      select.prop('disabled', true)
    else
      input.prop('disabled', false)
      input_numeric.prop('disabled', false)
      select.prop('disabled', false)

    false
