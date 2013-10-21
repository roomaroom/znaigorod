@init_auth_before_add_my_afisha = ->
  $('.new_my_afisha').click ->
    target = $(this)
    if $('.header .dashboard .user_name').length
      window.location.href = $(this).attr('href')
      return false
    else
      save_unauthorized_action(target)

    $.ajax
      url: '/my/sessions/new'
      success: (response, textStatus, jqXHR) ->
        return false if $('body .sign_in_with').length
        wrapped = $("<div>#{response}</div>")
        $('.social_signin_links', wrapped).removeClass('no_js').addClass('auth_links')
        $('h2', wrapped).remove()
        signin_container = $('<div class="sign_in_with" />').appendTo('body').hide().html($('.new_session', wrapped).html())
        signin_container.dialog
          autoOpen: true
          draggable: false
          modal: true
          resizable: false
          title: 'Необходима авторизация'
          width: '500px'
          open: ->
            init_auth()
            true
          close: (event, ui) ->
            $(this).dialog('destroy')
            $(this).remove()
            true

        true
    false
  true
