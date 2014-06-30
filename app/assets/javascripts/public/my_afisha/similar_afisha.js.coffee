$ ->
  $('#afisha_title').focusout ->
    $.ajax
      type: 'post'
      url: '/similar_afishas'
      data:
        title: $('#afisha_title').val()
      success: (response) ->
        if response
          $('.similar_afishas').empty()
          $('.similar_afishas').append(response)
          $('.similar_afishas').show()
        else
          $('.similar_afishas').hide()
