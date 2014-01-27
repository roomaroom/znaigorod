fileSelected = ->
  $('#work_image', '.new_work').val() != ''

agreeTerms = ->
  $('input[name="work[agree]"]', '.new_work').is(':checked')

@handleWorkAddition = ->
  submit = $('.submit', '.new_work')
  submit.attr('disabled', 'disabled').addClass('disabled')

  $('#work_image, input[name="work[agree]"]').change ->
    submit.removeAttr('disabled').removeClass('disabled') if fileSelected() && agreeTerms()
