@init_contests = () ->
  $.scrollTo($('.contest .work'), 500, { offset: {top: -20} })
  true

@init_add_work_to_contest = () ->
  wrapper = $('.new_work_wrapper')

  $.fn.append_work_from = (response) ->
    $(this).hide()
    $('.winners').hide()
    $('.works').hide()

    wrapper.append(response)

  $.fn.submit_form = (response) ->
    if !$(response).find('form').length
      remove_add_work_form()
      show_link()

      $('.works').show()
      $('.works').replaceWith(response)

  remove_add_work_form = () ->
    $('.ajaxed_item', wrapper).remove()

  show_link = () ->
    $('.add_work_link').show()

  cancel_handler = () ->
    $('.cancel', wrapper).on 'click', ->
      remove_add_work_form()
      show_link()

      $('.winners').show()
      $('.works').show()
      false

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

    # в респонсе пришла форма для загрузки работы
    switch target.attr('class')
      when 'add_work_link' then target.append_work_from(jqXHR.responseText)
      else target.submit_form(jqXHR.responseText)

    cancel_handler()
