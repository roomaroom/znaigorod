@init_similar_afishas = () ->
  $('#afisha_title').focusout ->
    $.ajax
      type: 'post'
      url: '/similar_afishas'
      data:
        title: $('#afisha_title').val()
      success: (response) ->
        wrapper = $("<div />").append(response)

        if $.trim($(wrapper).html()) == ''
          $('.similar_afishas').hide()
          $('.preview').show()
        else
          $('.preview').hide()
          $('.similar_afishas').empty()
          $('.similar_afishas').append(response)
          $('.similar_afishas').show()


  $('body').on 'click', '.yes', ->
    $('.preview').show()
    $('.similar_afishas').hide()
