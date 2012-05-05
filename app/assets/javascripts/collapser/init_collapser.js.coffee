@init_collapser = ->
  $('.mini_poster', '.item').click ->
    $this = $(this)

    context = $this.closest('.item')

    #$('.opened', context).removeClass('opened').find('.description').hide()

    #$this.parent().toggleClass('opened')

    #$this.next('.description').show()

    false
