@init_contests = () ->
  $.scrollTo($('.contest .work'), 500, { offset: {top: -20} })

  true

@init_contest_agreement = () ->
  $('.agreement_link').on 'click', ->
    $('.agreement_text').fadeToggle()

    false

@init_auth_for_contest = () ->
  wrapper = $('.new_work_wrapper')

  $('.auth_for_contest', wrapper).on 'click', ->
    $.ajax
      url: '/my/sessions/new'
      success: (response, textStatus, jqXHR) ->
        signin_container = $('<div class="sign_in_with" />').appendTo('body').hide().html(response)
        signin_container.dialog
          autoOpen: true
          draggable: false
          modal: true
          resizable: false
          title: 'Необходима авторизация'
          width: '500px'
          open:
            init_auth()
          close: (event, ui) ->
            $(this).dialog('destroy')
            $(this).remove()
            true

    true
  false
