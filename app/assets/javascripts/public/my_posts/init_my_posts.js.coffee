beforeImageInsert = (h) ->
  textarea = $(h.textarea)

  before = textarea.val()[0...h.caretPosition]
  after = textarea.val()[(h.caretPosition + h.selection.length)...textarea.val().length]

  file_input = $('.upload_gallery_images #gallery_image_file')

  file_input.fileupload
    dataType: 'json'

    done: (e, data) ->
      url = data.result.files[0].url
      textarea.val("#{before}#{url}#{after}")

    fail: (e, data) ->
      message = data.jqXHR.responseText
      $('.message_wrapper').text(message).show().delay(5000).slideUp('slow')

  file_input.click()

markItUpSettings = ->
  settings = clone(mySettings)

  imageButton = {
    name:'Изображение'
    className: 'image_button',
    beforeInsert: (h) ->
      beforeImageInsert(h)
  }

  settings.markupSet.push(imageButton)

  settings

init_markitup = ->
  $('.markitup').markItUp(markItUpSettings())

@init_my_posts = ->
  init_markitup()
