@init_email_form = () ->

  email_request_form = $("#email_request_form").dialog
    autoOpen: false
    draggable: false
    modal: true
    position: ['center', 'center']
    resizable: false
    title: 'Пожалуйста укажите E-mail'
    width: '450px'
    open: (evt, ui) ->
      $('body').css('overflow', 'hidden')
    close: (event, ui) ->
      $('body').css('overflow', 'auto')

  $('#email_request_form').submit ->
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
        $("#email_request_form").remove()
        return false

    return false

  dateToStorage = () ->
    current = new Date()
    set = new Date(window.localStorage.getItem('last_dialog_show'))
    unless set == null
      if current > set.addDays(1)
        window.localStorage.setItem('last_dialog_show', current)
        $('#email_request_form').dialog('open')
    else
      window.localStorage.setItem('last_dialog_show', current)
      $('#email_request_form').dialog('open')


  dateToStorage()
