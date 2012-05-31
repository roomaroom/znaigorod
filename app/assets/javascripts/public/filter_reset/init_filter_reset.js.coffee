@init_filter_reset = () ->
  filters = $('.filters')
  $('.reset').click ->
    $this = $(this)
    context = $this.closest('.filter').attr('class').replace('filter ', '')
    switch context
      when 'by_eating_categories', 'by_funny_categories', 'by_affiche_categories', 'by_tag', 'by_payment', 'by_cuisine', 'by_feature', 'by_offer'
        $('.'+context+' ul a').removeClass('active')
        break
      when 'by_time', 'by_amount'
        target = $('#'+context)
        max = target.slider('option', 'max')
        target.slider('values', [0,max])
        break

    filters.trigger('changed')

    false
