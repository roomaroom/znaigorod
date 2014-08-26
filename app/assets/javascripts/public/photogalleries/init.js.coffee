@init_next_image = ->
  selected = $('a.selected', 'div.photogallery')
  next = selected.parent().next().find('a')[0]
  prev = selected.parent().prev().find('a')[0]

  if selected.length
    $('.js-next-image').click ->
      next.click() if selected.parent().next().find('a').length

    $('.js-prev-image').click ->
      prev.click() if selected.parent().prev().find('a').length

add_uploaded_image = (image) ->
  uploaded_list = $('.upload_work_wrapper')
  uploaded_list
    .append("
      <div class='photogalleries_works' id='photogalleries_work__#{image.id}'>
        <img src='#{image.thumbnailUrl}' width='#{image.width}' height='#{image.height}' title='#{image.name}'>
        <a href='#{image.deleteUrl}' data-method='delete' data-remote='true' rel='nofollow' data-confirm='Вы точно хотите удалить эту картинку?'>Удалить</a>
      </div>
    ")
    .on 'ajax:success', (evt, response) ->
      photogalleries_work = $(evt.target).closest('.photogalleries_works')
      $('.'+photogalleries_work.attr('id')).remove()
      photogalleries_work.remove()
      false

@upload_works = ->
  $('#work_upload').fileupload
    acceptFileTypes:  /(\.|\/)(gif|jpe?g|png)$/i
    dataType:         'json'
    add: (e, data) ->
      file = data.files[0]
      data.context = $(tmpl("template-upload", file))
      $('.upload_wrapper').append(data.context)
      data.submit()
      true
    maxFileSize:      10000000
    url: ''
    done:  (evt, data) ->
      for file in  data.result.files
        add_uploaded_image file
    start: (e) ->
      $('.upload_wrapper').slideDown()
      true
    stop: (e) ->
      $('.upload_wrapper').slideUp()
      true
