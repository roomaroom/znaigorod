@init_manipulate_slave_organizations = ->
  $(document).on 'click', '.delete_slave_organization', ->
    $(this).parent().attr('class', 'form')

  $('.slave_organizations').on 'ajax:complete', (evt, jqXHR)->
    $(this).find('.form').remove()
    $(this).find('ul').append(jqXHR.responseText)

    $(this).find('#title').autocomplete
      minLength: 2,
      select: (event, ui)->
        $(this).val(ui.item.label)
        form = $(this).parents('form')
        action = form.attr('action').split('/')
        action.pop()
        action.push ui.item.value
        action = action.join('/')
        form.attr('action', action)

        false
      source: $('input#title').data('organizations')
