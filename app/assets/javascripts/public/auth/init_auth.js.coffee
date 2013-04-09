draw_popup = (url, width, height, name) ->
  left = (screen.width/2)-(width/2)
  top = (screen.height/2)-(height/2)
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top)

save_comment = () ->
  unless (typeof(window.localStorage) == 'undefined')
    window.localStorage.clear()
    window.localStorage.setItem('comment_body', $('form textarea', '.comments').val())
    if $('.comment_wrapper.active', '.comments').length
      window.localStorage.setItem('comment_id',   $('.comment_wrapper.active', '.comments').parent().attr('id'))
    else
      window.localStorage.setItem('comment_id', 'new_comment')

@init_auth = () ->
  $('.auth_links').on 'click', (evt) ->
    target = $(evt.target)
    if target.is('a')
      save_comment()
      draw_popup(target.attr('href'), 700, 400, 'Авторизация')

    return false
