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

handlePreview = ->
  form = $('.my_post_form')

  checkboxes = $('.post_categories_input, .post_kind_input', form)
  textInputs = $('#post_title, .markItUpEditor')
  tagsInput = $('#post_tag')

  checkboxes.on 'change', ->
    form.trigger('preview')

  textInputs.on 'keyup', ->
    form.trigger('preview')

  tagsInput.on 'change', ->
    form.trigger('preview')

  form.on 'preview', ->
    serialized = $('input[name!=_method], textarea', form)
    $.post('/my/posts/preview', serialized)
      .done (data) ->
        $('.show_preview').html(data)

linkWithAutocomplete = ->
  input = $('#post_link_with_title')
  target = $(input.data('target'))
  reset = $(input.data('reset'))

  input.autocomplete
    source: input.data('autocomplete-source')
    minLength: 2

    focus: (event, ui) ->
      $(this).val(ui.item.label)
      false

    select: (event, ui) ->
      $(this).val(ui.item.label)
      target.val(ui.item.value)
      reset.val('')
      false

linkWithChange = ->
  $('.link_with_change').click ->
    $('.link_with_content').closest('.link_with_wrapper').hide()
    $('.post_link_with_title').removeClass('linked').addClass('not_linked')
    $('#post_link_with_reset').val('true')
    false

handleLinkWith = ->
  linkWithAutocomplete()
  linkWithChange()

@initMyPosts = ->
  initMarkitup()
  handleImageButtonClick()
  initTagit()
  handlePreview()
  handleLinkWith()
