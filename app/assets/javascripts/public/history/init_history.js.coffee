@init_history = () ->
  filters = $('.filters')
  History = window.History
  unless History.enabled
    false
