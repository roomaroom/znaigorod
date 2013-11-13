@init_email_form = () ->
  @email_request_form = $("#email_request_form").dialog
    autoOpen: false
    draggable: false
    #height: 'auto'
    modal: true
    position: ['center', 'center']
    resizable: false
    title: 'Введите ваш E-mail'
    #height: '300px'
    #minHeight: '300px'
    width: '350px'
    open: (evt, ui) ->
      $('body').css('overflow', 'hidden')
    close: (event, ui) ->
      $('body').css('overflow', 'auto')
      $(this).dialog('destroy').remove()

  $('#email_request_form').submit ->
    email = $('#email_request_form #account_email').val()
    if email.length && !is_email(email)
      $('#email_request_form #account_email').closest('.line').after("<div style='color: red'>E-mail указан неверно =(</div>")
      $('#email_request_form #account_email').css
        'border-color': 'red'
      return false
  true

  @email_request_form

  show_on_main_page = ->
    unless window.localStorage.getItem('email_request_form_main_page')
      @email_request_form.dialog('open')
      window.localStorage.setItem('email_request_form_main_page',true)

  show_on_main_page() if window.location.pathname == "/"
