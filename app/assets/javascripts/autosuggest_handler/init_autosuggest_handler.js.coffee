$.fn.add_autosuggest = () ->
  $this = $(this)

  $this.autocomplete
    source: (request, response) ->
      $.ajax
        url: '/organizations.json'
        data: {utf8: 'true', q: request.term}
        success: (data) ->
          response( $.map( data, ( item ) ->
            return {
              id: item.id
              label: item.term
              latitude: item.latitude
              longitude: item.longitude
              value: item.term
            }
          ))
    minLength: 2
    select: ( event, ui ) ->
      $('.autosuggest_organization_id', $(event.target).parent().parent()).val(ui.item.id).change()
      $('.autosuggest_organization_latitude', $(event.target).parent().parent()).val(ui.item.latitude).change()
      $('.autosuggest_organization_longitude', $(event.target).parent().parent()).val(ui.item.longitude).change()

  true

@init_autosuggest_handler = () ->
  init_clear_autosuggest() if $('.clear_autosuggest_link').length

  $('.autosuggest').add_autosuggest() if $('.autosuggest').length

  $('form').on('nested:fieldAdded', (event) ->
    $(event.field).find('.autosuggest').filter(':visible').last().add_autosuggest()
  )

  true

@init_clear_autosuggest = () ->
  $('.clear_autosuggest_link').on 'click', ->

    $('.autosuggest').val('')
    $('.autosuggest_organization_id').val('').change()
    $('.autosuggest_organization_latitude').val('').change()
    $('.autosuggest_organization_longitude').val('').change()

    false

  true
