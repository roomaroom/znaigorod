$ ->
  $('.my_posts_wrapper h2').on 'click', ->
    $this = $(this)
    parent = $this.parent('div')
    parent.children('div').toggle()
    parent.siblings('div').children('div').toggle()
