@init_email_form = () ->
  urls = ["/my/afisha/new", "/my/discounts/new", "/my/coupons/new", "/my/certificates/new"]
  forms = $("#new_discount, #new_coupon, #new_certificate, #new_afisha")

  email_request_form = $("#email_request_form").dialog
    autoOpen: false
    draggable: false
    modal: true
    position: ['center', 'center']
    resizable: false
    title: 'Пожалуйста укажите E-mail'
    width: '350px'
    open: (evt, ui) ->
      $('body').css('overflow', 'hidden')
    close: (event, ui) ->
      $('body').css('overflow', 'auto')
      unless urls.find(window.location.pathname) == undefined
        forms.submit()

  $('#email_request_form .properties_submit').click ->
    email = $('#email_request_form #account_email').val()
    if email.length && !is_email(email)
      $('#email_request_form #account_email').closest('.line').after("<div style='color: red'>E-mail указан неверно =(</div>")
      $('#email_request_form #account_email').css
        'border-color': 'red'
      return false
    $.ajax
      url: '/my/account'
      type: 'PUT'
      data: {account: { email: $('#email_request_form #account_email').val() } }
      success: (response, textStatus, jqXHR) ->
        $("#email_request_form").dialog('close')
        return false

    return false

  email_request_form

  unless (urls.find(window.location.pathname) == undefined)
    forms.find('.submit input').click ->
      $("#email_request_form").dialog('open')
      false


@show_email_request_form = ->
  $("#email_request_form").dialog('open')
