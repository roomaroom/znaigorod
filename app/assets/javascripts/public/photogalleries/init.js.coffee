@init_next_image = ->
  selected = $('a.selected', 'div.photogallery')
  next = selected.parent().next().find('a')[0]
  prev = selected.parent().prev().find('a')[0]

  if selected.length
    $('.js-next-image').click ->
      next.click() if selected.parent().next().find('a').length

    $('.js-prev-image').click ->
      prev.click() if selected.parent().prev().find('a').length

@test = ->
  $('#work_upload').fileupload
    acceptFileTypes:  /(\.|\/)(gif|jpe?g|png)$/i
    dataType:         'json'
    maxFileSize:      10000000
    url: ''
    done:  (evt, data) ->
      #console.log data
      #for file in  data.result.files
        #add_uploaded_image file
    submit:           (evt, data) ->
      #uploaded_files_count = $('.uploaded_list .comments_image', '.comments_images_wrapper').length
      #if (uploaded_files_count+data.originalFiles.length) > 5
        #alert 'Слишком много картинок! Вы можете загрузить не больше 5 картинок!'
        #throw 'Too many pics'
        #false
