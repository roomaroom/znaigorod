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

delay = (->
  timer = 0
  (callback, ms) ->
    clearTimeout timer
    timer = setTimeout(callback, ms)
)()

initTagit = ->
  tagitFor $('#question_tag')

tagitFor = (element) ->
  options = {
    allowSpaces:              true
    caseSensitive:            false
    closeAutocompleteOnEnter: true
    singleFieldDelimiter:     ', '

    autocomplete:
      delay:     0
      minLength: 1
      source:    element.data('autocomplete-source')
  }

  element.tagit options

initMarkitup = ->
  $('.markitup').markItUp(markItUpSettings())

markItUpSettings = ->
  settings = clone(mySettings)

  settings.afterInsert = (h) ->
    $('textarea[name="review[content]"]').trigger('preview')

  imageButton = {
    name:'Изображение'
    className: 'image_button'
    openWith: ''
    beforeInsert: (h) ->
      beforeImageInsert(h)
  }

  youtubeButton = {
    name: 'Видео с Youtube'
    className: 'youtube_button'
    replaceWith: '[![Добавление видео с Youtube:!:Просто вставьте сюда ссылку на видео с Youtube, например, http://www.youtube.com/watch?v=e-GYrbecb88]!]'
  }

  vimeoButton = {
    name: 'Видео с Vimeo'
    className: 'vimeo_button'
    replaceWith: '[![Добавление видео с Vimeo:!:Просто вставьте сюда ссылку на видео с Vimeo, например, http://vimeo.com/11192521]!]'
  }

  settings.markupSet.push(imageButton)
  settings.markupSet.push(youtubeButton)
  settings.markupSet.push(vimeoButton)

  settings


clone = (obj) ->
  return obj  if obj is null or typeof (obj) isnt "object"

  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])

  temp
