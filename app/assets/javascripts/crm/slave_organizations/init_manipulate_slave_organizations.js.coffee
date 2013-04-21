@init_manipulate_slave_organizations = ->
  $('.activities').on 'ajax:complete', (evt, jqXHR)->
    $('.slave_organization_form').html(jqXHR.responseText)

    $('#slave_organization_title').autocomplete
      minLength: 2,
      select: (event, ui)->
        $('#slave_organization_title').val(ui.item.label)
        action = $('.simple_form.slave_organization').attr('action').split('/')
        action.pop()
        action.push ui.item.value
        action = action.join('/')
        $('.simple_form.slave_organization').attr('action', action)

        false
      source: $('#slave_organization_title').data('organizations')

    $('#new_slave_organization').submit ->
      console.log '123'
      url = $(this).attr('action')
      primary_organization_id = $('#slave_organization_primary_organization_id').val()

      $.ajax
        type: 'PUT',
        url: url,
        data:
          slave_organization: { primary_organization_id: primary_organization_id },
        success: (data, textStatus, jqXHR)->
          $('.slave_organizations').replaceWith(data)

          false

      false
