@init_autosuggest_handler = () ->
  target = $('.autosuggest_target')
  autosuggest = $('.autosuggest')

  autosuggest.autocomplete
    source: (request, response) ->
      $.ajax
        url: '/manage/organizations.json'
        data: {q: request.term}
        success: (data) ->
          response( $.map( data, ( item ) ->
            return {
              label: item.term
              value: item.term
              id:    item.id
            }
          ))
    minLength: 3
    select: ( event, ui ) ->
      target.val(ui.item.id)
