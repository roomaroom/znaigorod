@init_email_form = () ->
  email_request_form = $("#email_request_form").dialog
    autoOpen: false
    draggable: false
    #height: 'auto'
    modal: true
    position: ['center', 'center']
    resizable: false
    title: 'Пожалуйста укажите E-mail'
    #height: '300px'
    #minHeight: '300px'
    width: '350px'
    open: (evt, ui) ->
      $('body').css('overflow', 'hidden')
    close: (event, ui) ->
      $('body').css('overflow', 'auto')

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
      data: { email: $('#email_request_form #account_email').val()  }
      beforeSend: () ->
        $("#email_request_form").dialog('close')
      success: (response, textStatus, jqXHR) ->
        return false

    return false

  email_request_form

@show_email_request_form = ->
  $("#email_request_form").dialog('open')
