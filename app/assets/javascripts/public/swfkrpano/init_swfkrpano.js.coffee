@init_swfkrpano = () ->
  link = $('#krpano a.tour_link')
  if link.length && link.attr('href').endsWith('.swf')
    swf = createswf(link.attr('href'), 'krpano', '740', '560')
    swf.embed('krpano')
    link.remove()
  if link.length && link.attr('href').match('ru09')
    data = "<iframe frameborder='0' width='740' height='560' src='#{link.attr('href')}'>" +
      "Ваш браузер не поддерживает плавающие фреймы!" +
      "</iframe>"
    $('#krpano').prepend(data)
    link.remove()
  false
