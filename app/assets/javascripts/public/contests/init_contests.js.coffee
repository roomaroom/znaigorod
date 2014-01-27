@init_contests = () ->
  $.scrollTo($('.contest .work'), 500, { offset: {top: -20} })
  true

@init_contest_agreement = () ->
  $('.agreement_link').on 'click', ->
    $('.agreement_text').fadeToggle()

    false

@init_auth_for_contest = () ->
  wrapper = $('.new_work_wrapper')

  wrapper.on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    # в респонсе пришла форма авторизации
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
