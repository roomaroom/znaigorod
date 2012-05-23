@init_seance_tabs = () ->
  $('.seance_tabs a').live 'click', ->
    $this = $(this)
    parent = $this.parent()
    false if parent.hasClass('active')
    parent.siblings().removeClass('active')
    parent.addClass('active')
    target = $this.parent().attr('id').replace('target_', '')
    $('table.sortable', $this.closest('.seance_tabs').next('.seances_wrapper')).hide()
    $('#'+target).show()
    false
