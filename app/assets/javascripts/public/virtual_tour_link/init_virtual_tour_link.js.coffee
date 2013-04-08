@init_virtual_tour_link = () ->
  block = $('.organization_info .virtual_tour_link').click (event) ->
    box_width = '790px'
    box_height = '760px'
    data = "<h1>#{$('h1', $(this).closest('.info')).text()}</h1>"
    data += "
      <div id='krpano'>
        <noscript><center>ERROR: Javascript not activated</center></noscript>
        <a href='#{$(this).attr('data-link')}' class='virtual_tour_link'>#{$(this).attr('data-link')}</a>
      </div>
      <div class='ad'>
        <a href='http://tomsk.3dtour.me/' class='3dtourme' rel='nofollow' target='_blank'>
          <img alt='Изготовление и размещение виртуальных туров' height='69' src='/assets/public/3dtour.png' width='740' />
        </a>
      </div>"
    $.colorbox
      width: box_width
      height: box_height
      html: data
      onComplete: () ->
        init_swfkrpano()
        true

    false

  true
