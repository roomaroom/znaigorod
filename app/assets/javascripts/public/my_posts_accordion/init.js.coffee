$ ->
  blocks = $('.js-accordion-body')
  blocks.hide()

  blocks.first().show()

  $('.my_posts_wrapper .panel_header h3').on 'click', ->
    $this = $(this)
    block = $this.parent().siblings('.js-accordion-body')
    block.fadeToggle()
