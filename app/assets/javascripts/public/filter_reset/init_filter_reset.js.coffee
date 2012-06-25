@init_filter_reset = () ->
  filters = $('.filters')
  $('.reset').click ->
    $this = $(this)
    context = $this.closest('.filter').attr('class').replace('filter ', '')
    switch context
      when 'by_categories', 'by_affiche_category', 'by_tag', 'by_payment', 'by_cuisine', 'by_feature', 'by_offer'
        $('.'+context+' ul a').removeClass('active')
        break
      when 'by_time', 'by_amount'
        target = $('#'+context)
        max = target.customslider('option', 'max')
        target.customslider('values', [0,max])
        break

    filters.trigger('changed')

    false
