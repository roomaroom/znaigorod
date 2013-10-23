@is_email = (email) ->
  regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/

  regex.test email

@init_payment = () ->
  $('a.payment_link').each ->
    link = $(this)
    link.click ->
      $.ajax
        type: 'GET'
        url: link.attr('href')
        success: (data, textStatus, jqXHR) ->
          container = $('<div class="payment_form_wrapper" />').appendTo('body').hide().html(data)
          title = 'Форма заказа'
          title = 'Оплата услуг' if $('#service_payment_details', container).length
          container.dialog
            width: 640
            title: title
            modal: true
            resizable: false
            create: (event, ui) ->
              $('body').css
                overflow: 'hidden'
              true
            beforeClose: (event, ui) ->
              $("body").css
                overflow: 'inherit'
            true
            open: ->
              init_actions_handler()
              true
            close: (event, ui) ->
              $(this).dialog('destroy')
              $(this).remove()
              true
          true

      false

    true

  if window.location.hash == '#buy_ticket'
    $('a.payment_link:first').click()

@init_actions_handler = ->
  $('.payment_form_wrapper form input[type=submit]').attr('disabled', 'disabled').addClass('disabled')

  $('.payment_form_wrapper form #copy_payment_phone').inputmask 'mask',
    'mask': '+7-(999)-999-9999'

  $('.payment_form_wrapper form #copy_payment_email').inputmask 'Regex',
    #regex: "[a-zA-Z0-9._%-]+@[a-zA-Z0-9-]+\\.[a-zA-Z]{2,4}"
    regex: "^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$"

  $('.payment_form_wrapper form input[type=submit]').click ->
    $('.payment_form_wrapper form').submit()
    false

  $('.payment_form_wrapper form').submit ->
    return false if $('.payment_form_wrapper .copies_with_seats input').length && !$('.payment_form_wrapper .copies_with_seats input:checked').length
    return false unless $('.payment_form_wrapper #copy_payment_phone').inputmask('isComplete')

    email = $('.payment_form_wrapper #copy_payment_email')
    return false if email.length && !is_email($('.payment_form_wrapper #copy_payment_email').val())

    true

  $('.payment_form_wrapper #copy_payment_phone, .payment_form_wrapper #copy_payment_email').keyup ->
    return false if $('.payment_form_wrapper .copies_with_seats input').length && !$('.payment_form_wrapper .copies_with_seats input:checked').length

    phone = $('.payment_form_wrapper #copy_payment_phone')
    email = $('.payment_form_wrapper #copy_payment_email')

    if email.length
      if phone.inputmask('isComplete') && is_email(email.val())
        $('input[type=submit]', phone.closest('form')).removeAttr('disabled').removeClass('disabled')
      else
        $('input[type=submit]', phone.closest('form')).attr('disabled', 'disabled').addClass('disabled')
    else
      if phone.inputmask('isComplete')
        $('input[type=submit]', phone.closest('form')).removeAttr('disabled').removeClass('disabled')
      else
        $('input[type=submit]', phone.closest('form')).attr('disabled', 'disabled').addClass('disabled')

    true

  $('.payment_form_wrapper .copies_with_seats input').change ->
    unless $('.payment_form_wrapper .copies_with_seats input:checked').length
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
      return false
    if $('.payment_form_wrapper #copy_payment_phone').inputmask 'isComplete'
      $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
    else
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
    true

  $('.payment_form_wrapper #service_payment_amount').keyup ->
    if $(this).val() && $('.payment_form_wrapper #service_payment_details').val()
      $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
    else
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
    true

  $('.payment_form_wrapper #service_payment_details').keyup ->
    if $(this).val() && $('.payment_form_wrapper #service_payment_amount').val()
      $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
    else
      $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
    true

  true

true
