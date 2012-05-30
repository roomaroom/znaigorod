@init_remote_pagination = () ->
  $('.pagination').on 'ajax:success', (event, data, status) ->
    list_block = $('.list')
    list_block.animate({opacity: 0}, 900, ->
      list_block.html('<img src="/assets/preloader.gif" width=48 height=48 style="margin: 0 auto; display: block"/>').animate({opacity: 1}, 900, ->
        list_block.html(data).animate({opacity: 1}, 900)
        init_remote_pagination()
      )
    )
