@init_filter_preset_button = () ->
  $('.pod_preset').click ->
    $this = $(this)
    type = $this.attr('id')
    range_slider = $('#by_time')

    switch type
      when 'morning'
        range_slider.slider('values', 0, 0)
        range_slider.slider('values', 1, 6)
        break

      when 'day'
        range_slider.slider('values', 0, 6)
        range_slider.slider('values', 1, 12)
        break

      when 'evening'
        range_slider.slider('values', 0, 12)
        range_slider.slider('values', 1, 18)
        break

      when 'night'
        range_slider.slider('values', 0, 18)
        range_slider.slider('values', 1, 24)
        break

    false
