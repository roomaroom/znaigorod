@init_account_edit = () ->
  $('.properties_form #edit_account').submit ->
    email = $('.properties_form #edit_account #account_email').val()
    if email.length && !is_email(email)
      $('.properties_form #edit_account #account_email').closest('.line').after("<div style='color: red'>E-mail указан неверно =(</div>")
      $('.properties_form #edit_account #account_email').css
        'border-color': 'red'
      return false
  true

@init_account_filter_with_avatar = () ->
  $('.filters_wrapper .account #with_avatar').change ->
    block = $(this).closest('div')
    $(this).attr('disabled', 'disabled')
    $('label', block).attr('disabled', 'disabled').css('color', '#999')
    window.location.replace($('#with_avatar_link', block).val())
    true

  true

@init_help = ->
  left = $('.show_help').position().left - 190
  $('.help').css('left', left).prepend('<a class="close" title="закрыть" href="#">X</a>')
  $('.show_help').click ->
    $('.help').toggle()
    false
  $('.help .close').click ->
    $('.help').toggle()
    false

@account_afisha_remove = () ->
  $('.trash').on 'ajax:success', (evt, data) ->
    id = $(evt.target).closest('.item').attr('id')
    $("##{id}").each ()->
      $(this).closest('li').remove()

    $('#events_filter .ui-state-default a, #discounts_filter .ui-state-default a').each (index, elem) ->
      switch elem.href.split('/').last()
        when '#all' then elem.innerHTML = "Все (#{data.all})"
        when '#draft' then elem.innerHTML = "Черновики (#{data.draft})"
        when '#published' then elem.innerHTML = "Опубликованные (#{data.published})"
      true

@init_account_extend = () ->

  account_afisha_remove()
  target = $('#account_avatar')
  target.on 'change', ->
    $(this).parents('form').submit()

    true

  target.hide()
  link = $('<a href="#">изменить фото</a>')
  target.closest('form').append(link)

  link.click ->
    target.click()

    false

@init_account_social_actions = () ->
  $('.images_list').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)
    target.closest('li').remove() if target.hasClass('trash')

  $('.account_show .left, .invitations_wrapper, .accounts_list').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length
      save_unauthorized_action(target)
      return false if $('body .sign_in_with').length
      $('.cloud_wrapper', target.closest('.social_actions')).remove()

      signin_container = $('<div class="sign_in_with" />').appendTo('body').hide().html(response)
      signin_container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Необходима авторизация'
        width: '500px'
        close: (event, ui) ->
          $(this).dialog('destroy')
          $(this).remove()
          true

      init_auth()

      return false

    if target.hasClass('add_private_message') || target.hasClass('invite')
      container = $('<div class="message_form_wrapper" />').appendTo('body').hide().html(response)
      form = $('form', container)

      form.submit () ->
        $.ajax
          url: form.attr('action')
          type: 'POST'
          data: form.serialize()
          success: (response, textStatus, jqXHR) ->
            container.dialog('close')
            unless $('.message_wrapper').length
              $('body').prepend('<div class=\'message_wrapper\'>')
            $('.message_wrapper').text('Сообщение успешно отправлено!').show().delay(5000).slideUp('slow')
            true

        false

      container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Новое сообщение'
        width: '500px'
        create: (event, ui) ->
          $('.submit_dialog', form).attr('disabled', 'disabled')
          true
        close: (event, ui) ->
          $(this).dialog('destroy')
          $(this).remove()
          true

      $('textarea', container).keyup ->
        if $(this).val()
          $('input[type=submit]', $(this).closest('form')).removeAttr('disabled').removeClass('disabled')
        else
          $('input[type=submit]', $(this).closest('form')).attr('disabled', 'disabled').addClass('disabled')
        true

  true
