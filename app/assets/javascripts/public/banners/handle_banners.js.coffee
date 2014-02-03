@handleBanners = ->
  $('.generate').click ->
    submit = $(this)

    wrapper = submit.closest('.banner')
    img = $('img', wrapper)
    textarea = $('.code', wrapper)

    hidden_code = $('.hidden_code', wrapper).val()
    new_code = $(hidden_code).clone()

    origin_width = parseInt(img.attr('width'))
    origin_height = parseInt(img.attr('height'))
    ratio = origin_width / origin_height

    user_width = parseInt($('.width', wrapper).val()) || origin_width
    user_height = parseInt(user_width / ratio)

    $('img', new_code).attr('width', user_width).attr('height', user_height)
    textarea.val new_code[0].outerHTML


