@init_swfkrpano = () ->
  link = $('#krpano a.virtual_tour_link')

  if link.length && link.attr('href').compact().match('milana')
    data =
    "<object type='application/x-shockwave-flash' id='pano' name='pano' align='middle' data='#{link.attr('href')}' width='740' height='500'>" +
      "<param name='quality' value='high'>" +
      "<param name='bgcolor' value='#ffffff'>" +
      "<param name='allowscriptaccess' value='sameDomain'>" +
      "<param name='allowfullscreen' value='true'>" +
      "<param name='base' value='.'>" +
      "<param name='wmode' value='opaque'>" +
    "</object>"
    $('#krpano').prepend(data)
    link.remove()
    return true

  if link.length && link.attr('href').compact().endsWith('.swf')
    swf = createswf(link.attr('href'), 'krpano', '740', '560')
    swf.embed('krpano')
    link.remove()
    return true

  if link.length && link.attr('href').compact().match('ru09')
    data = "<iframe frameborder='0' width='740' height='560' src='#{link.attr('href')}'>" +
      "Ваш браузер не поддерживает плавающие фреймы!" +
      "</iframe>"
    $('#krpano').prepend(data)
    link.remove()
    return true

  false
