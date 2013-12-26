@init_file_upload = () ->
  $('.file_upload').fileupload
    dataType: "script"
    add: (e, data) ->
      file = data.files[0]
      data.context = $(tmpl("template-upload", file))
      $('.upload_wrapper').append(data.context)
      data.submit()
      true
    done: (e, data) ->
      $(data.context).slideUp ->
        $(this).remove()
        true
      init_ajax_delete()
      true
    start: (e) ->
      $('.upload_wrapper').slideDown()
      true
    stop: (e) ->
      $('.upload_wrapper').slideUp()
      true

  true
