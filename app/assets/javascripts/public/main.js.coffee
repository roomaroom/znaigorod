$ ->
  init_main_page_banner()     if $('.main_page_block').length
  init_seance_tabs()          if $('.seance').length
  init_tablesorter()          if $('.sortable').length

  if ('.filter').length
    init_filter_collapser()
    init_filter_reset()

    init_filter_resizer()       if $('.filter.by_date').length
    init_range_slider()         if $('.filter.by_date').length
