@init_collapse = ->
  $('.js-slider').on 'click', ->
    $this = $(this)

    if $this.hasClass('open')
      $this.siblings('.collapse').slideUp 'fast', ->
        $this.removeClass('open')
        $(this).removeClass('in')
    else
      $this.addClass('open')
      $this.siblings('.collapse').slideDown 'fast', ->
        $(this).addClass('in')

    false

  return
