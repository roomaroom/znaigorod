clone = (obj) ->
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

    fail: (e, data) ->
      message = data.jqXHR.responseText
      $('.message_wrapper').text(message).show().delay(5000).slideUp('slow')

markItUpSettings = ->
  settings = clone(mySettings)

  settings.afterInsert = (h) ->
    $('textarea[name="post[content]"]').trigger('preview')

  imageButton = {
    name:'Изображение'
    className: 'image_button'
    openWith: ''
    beforeInsert: (h) ->
      beforeImageInsert(h)
  }

  settings.markupSet.push(imageButton)

  settings

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

handleImageButtonClick = ->
  $('.image_button').click ->
    $('#gallery_image_file').focus().trigger('click')

initTagit = ->
  tagitFor $('#post_tag')

handleEditorPreview = ->
  textarea = $('textarea[name="post[content]"]')

  textarea.on 'keyup', ->
    textarea.trigger('preview')

  textarea.on 'preview', ->
    text = $(this).val()
    target = $('.preview')

    $.post('/my/posts/preview', { text: text })
      .done (data) ->
        target.html(data)

setPreviewTop = ->
  previewWrapperTop = $('.preview_wrapper').position().top
  postContentTop = $('.post_content').position().top

  $('.preview_wrapper').css('margin-top', postContentTop - previewWrapperTop)

handleLinkWithAutocomplete = ->
  input = $('#post_link_with')

  input.autocomplete
    source: input.data('autocomplete-source')
    minLength: 2

@initMyPosts = ->
  initMarkitup()
  handleImageButtonClick()
  initTagit()
  handleEditorPreview()
  setPreviewTop()
  handleLinkWithAutocomplete()
