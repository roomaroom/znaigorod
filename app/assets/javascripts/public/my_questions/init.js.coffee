@initMyQuestions = ->
  initMarkitup()
  initTagit()

  form = $('.my_review_form')

  textInputs = $('#question_title, .with-preview')
  tagsInput = $('#question_tag')

  textInputs.on 'keyup', ->
    delay (->
      form.trigger('preview')
    ), 1000

  tagsInput.on 'change', ->
    delay (->
      form.trigger('preview')
    ), 1000

  form.on 'preview', ->
    serialized = $('input[name!=_method], textarea', form)
    $.post('/my/questions/preview', serialized)
      .done (data) ->
        $('.reviews_show').html(data)

initTagit = ->
  tagitFor $('#question_tag')

initMarkitup = ->
  $('.markitup').markItUp(markItUpSettings())

