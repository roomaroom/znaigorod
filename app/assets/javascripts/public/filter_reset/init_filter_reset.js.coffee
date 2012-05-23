@init_filter_reset = () ->
  filters = $('.filters')
  $('.reset').click ->
    $this = $(this)
    context = $this.closest('.filter').attr('class').replace('filter ', '')
    switch context
      when 'by_category', 'by_tag'
        $('.'+context+' ul a').removeClass('active')
        break
      when 'by_time', 'by_amount'
        target = $('#'+context)
        max = target.slider('option', 'max')
        target.slider('values', [0,max])
        break

    filters.trigger('changed')

    false
