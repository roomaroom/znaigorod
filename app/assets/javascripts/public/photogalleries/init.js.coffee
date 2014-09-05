@init_next_image = ->
  selected = $('a.selected', 'div.photogallery')
  next = selected.parent().next().find('a')[0]
  prev = selected.parent().prev().find('a')[0]

  if selected.length
    $('.js-next-image').click ->
      next.click() if selected.parent().next().find('a').length

    $('.js-prev-image').click ->
      prev.click() if selected.parent().prev().find('a').length

# Создание множественных работ
delete_errors_messages = ->
  errors = $(".errors_wrapper")
  errors.each (index, error) ->
    error.remove()
    return

add_uploaded_image = (image) ->
  uploaded_list = $('.upload_work_wrapper')
  uploaded_list
    .append("
      <div class='photogalleries_works' id='photogalleries_work__#{image.id}'>
        <div class='work_image'>
          <a href='#{image.url}' target='_blank'><img src='#{image.thumbnailUrl}' width='#{image.width}' height='#{image.height}' title='#{image.name}'></a>
          <a href='#{image.deleteUrl}' class='show_tipsy icon-trash' original-title='Удалить' title='Удалить' data-method='delete' data-remote='true' rel='nofollow' data-confirm='Вы точно хотите удалить эту картинку?'>Удалить</a>
        </div>
        <textarea class='js-edit-description description' rows='13' cols='40' placeholder='Просто введите здесь описание' data-url='#{image.updateUrl}'></textarea>
      </div>
    ")
    .on 'ajax:success', (evt, response) ->
      photogalleries_work = $(evt.target).closest('.photogalleries_works')
      $('.'+photogalleries_work.attr('id')).remove()
      photogalleries_work.remove()
      false

change_description = ->
  $('body').on 'change', '.js-edit-description', ->
    $.ajax
      type: 'PUT'
      url: $(this).attr('data-url')
      data:
        'description' : $(this).val()
        'agree' : $('#agree').val()

@i_agree_with_u = ->
  $('#agree').change ->
    if $('#work_upload').is(':disabled')
      $('#work_upload').prop('disabled', false)
    else
      $('#work_upload').prop('disabled', true)

@upload_works = ->
  $('#work_upload').fileupload
    acceptFileTypes:  /(\.|\/)(gif|jpe?g|png)$/i
    dataType:         'json'
    maxFileSize:      10000000
    url: ''
    add: (e, data) ->
      file = data.files[0]
      data.context = $(tmpl("template-upload", file))
      $('.upload_wrapper').append(data.context)
      data.submit()
      true

    start: (e) ->
      $('.upload_wrapper').slideDown()
      true

    stop: (e) ->
      $('.upload_wrapper').slideUp()
      true

    done:  (evt, data) ->
      delete_errors_messages()
      for file in  data.result.files
        add_uploaded_image file
      $('.new_work_wrapper').show()

    error: (evt,data) ->
      errors = $.parseJSON(evt.responseText)
      errors.errors[0].error.each (error) ->
        $(".upload_work_wrapper").append("<div class='errors_wrapper' style='color: red'><p>#{error}</p></div>")
        return

  change_description()

@init_toggle = ->
  $('.js-toggle-more-info').click ->
    $('.more_info').toggle('slow')
