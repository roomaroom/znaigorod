@save_unauthorized_action = (target) ->
  if window && window.localStorage
    $.fn.reverse = [].reverse
    array = target.parents().reverse().map( ->
      elem = "#{this.tagName}"
      elem = "#{elem}.#{$(this).attr('class').compact().split(' ')[0]}" if $(this).attr('class')
      elem.toLowerCase()
    ).get()
    target_elem = "#{$(target).prop('tagName')}"
    target_elem = "#{target_elem}.#{$(target).attr('class').compact().split(' ')[0]}" if $(target).attr('class')
    array.push(target_elem.toLowerCase())
    window.localStorage.removeItem('unauthorized_action_target')
    window.localStorage.setItem('unauthorized_action_target', array.join(' '))

  true

@apply_unauthorized_action = () ->
  if window && window.localStorage && window.localStorage.getItem('unauthorized_action_target') && $('.header .dashboard .user_name').length
    setTimeout ->
      $(window.localStorage.getItem('unauthorized_action_target').compact()).click()
      window.localStorage.removeItem('unauthorized_action_target')
      true
    , 500

  true
