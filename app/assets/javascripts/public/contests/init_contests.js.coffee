@init_contests = () ->
  $.scrollTo($('.contest .work'), 500, { offset: {top: -20} })
  true

@init_add_work_to_contest = () ->
  wrapper = $('.add_work_wrapper')

  remove_add_work_form = () ->
    $('.new_work', wrapper).remove()

  show_link = () ->
    $('.js-add-work').show()

  cancel_handler = () ->
    $('.cancel', wrapper).on 'click', ->
      remove_add_work_form()
      show_link()
      false

  wrapper.on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    wrapper.append(response)

    target.hide()
    $('.works').hide()

    cancel_handler()

