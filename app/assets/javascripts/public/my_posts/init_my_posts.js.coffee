clone = (obj) ->
  return obj  if obj is null or typeof (obj) isnt "object"

  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])

  temp

beforeImageInsert = (h) ->
  console.log 'beforeInsert'
  console.log $('.upload_gallery_images #gallery_image_file')

  $('.upload_gallery_images #gallery_image_file').click()

  #upload_form = $('.upload_gallery_images')
  ##file_input = $('#gallery_image_file', upload_form)

  ##file_input.fileupload
    ##autoUpload: true

    ##dataType: 'script'

  #dialog = init_modal_dialog
    #class: 'upload_gallery_images'
    #height: 390
    #title: upload_form.data('title')
    #width:  640

  #dialog.html(upload_form)

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
