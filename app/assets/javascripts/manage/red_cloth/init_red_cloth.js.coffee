@init_red_cloth = () ->
  $('textarea.description').keyup ->
    $.post '/manage/red_cloth', { text: $(this).val() }, (data) ->
      $('.red_cloth').html(data)
