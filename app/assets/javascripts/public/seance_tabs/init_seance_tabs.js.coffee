@init_seance_tabs = () ->
  firsts = $('.seances_wrapper table:first', '.seance')
  $('.seances_wrapper table', '.seance').not(firsts).hide()

  $('.seance_tabs a').click ->
    $this = $(this)
    parent = $this.parent()
    false if parent.hasClass('active')
    parent.siblings().removeClass('active')
    parent.addClass('active')
    target = $this.parent().attr('id').replace('target_', '')
    $('table.sortable', $this.closest('.seance_tabs').next('.seances_wrapper')).hide()
    $('#'+target).show()
    false
