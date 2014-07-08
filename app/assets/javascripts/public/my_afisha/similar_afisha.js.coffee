@init_similar_afishas = () ->
  $('#afisha_title').focusout ->
    $.ajax
      type: 'post'
      url: '/similar_afishas'
      data:
        title: $('#afisha_title').val()
      success: (response) ->
        if response
          $('.preview').hide()
          $('.similar_afishas').empty()
          $('.similar_afishas').append(response)
          $('.similar_afishas').show()
        else
          $('.similar_afishas').hide()
          $('.preview').show()


  $('body').on 'click', '.yes', ->
    $('.preview').show()
    $('.similar_afishas').hide()
