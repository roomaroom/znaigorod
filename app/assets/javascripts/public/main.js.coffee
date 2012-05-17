$ ->
  init_tablesorter()    if $('.sortable').length
  init_filter_resizer() if $('.filter.by_date').length
  init_range_slider()   if $('.filter.by_date').length
  init_filter_reset()   if $('.filter').length
  init_filter_preset_button() if $('.filter').length
