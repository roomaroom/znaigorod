@clone = (obj) ->
  return obj  if obj is null or typeof (obj) isnt "object"

  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])

  temp

beforeImageInsert = (h) ->
  textarea = $(h.textarea)

  before = textarea.val()[0...h.caretPosition]
  after = textarea.val()[(h.caretPosition + h.selection.length)...textarea.val().length]

  file_input = $('.upload_gallery_images #gallery_image_file')

  file_input.fileupload
    dataType: 'json'

    done: (e, data) ->
      url = data.result.files[0].url
      textarea.val("#{before}!#{url}!#{after}")
      textarea.trigger('preview')

    start: (e) ->
      top = $(document).scrollTop()
      $('body').addClass('non_scrollable')

      $('.loader').show().offset
        left: 0
        top: top

    stop: (e) ->
      $('body').removeClass('non_scrollable')
      $('.loader').hide()

    fail: (e, data) ->
      message = data.jqXHR.responseText
      $('.message_wrapper').text(message).show().delay(5000).slideUp('slow')

@markItUpSettings = ->
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

@tagitFor = (element) ->
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

handleImageButtonClick = ->
  $('.image_button').click ->
    $('#gallery_image_file').focus().trigger('click')

initTagit = ->
  tagitFor $('#review_tag')

@delay = (->
  timer = 0
  (callback, ms) ->
    clearTimeout timer
    timer = setTimeout(callback, ms)
)()

handlePreview = ->
  form = $('.my_review_form')

  textInputs = $('#review_title, .with-preview')
  tagsInput = $('#review_tag')

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
    $.post('/my/reviews/preview', serialized)
      .done (data) ->
        $('.reviews_show').html(data)

handleEighteenPlus = ->
  label = $('#review_categories_eighteen_plus').closest('.checkbox')
  label.addClass('eighteen_plus').append(' <div class="info show_tipsy fa fa-info-circle" title="Обзоры из категории «18+» не показываются на списке обзоров и в общем поиске по сайту."></div>')

@initMyReviews = ->
  initMarkitup()
  handleImageButtonClick()
  initTagit()
  handlePreview()
  handleEighteenPlus()
