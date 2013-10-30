@init_discounts_account_tabs = () ->
  $('#discounts_filter').tabs()
  window_scroll_init('all')
  $('#discounts_filter').on "tabsselect", (event, ui) ->
    $(window).unbind('scroll')
    window_scroll_init(ui.panel.id)
