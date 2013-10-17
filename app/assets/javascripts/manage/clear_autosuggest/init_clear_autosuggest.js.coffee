@init_clear_autosuggest = () ->
  $('.clear_autosuggest_link').on 'click', ->

    $('.autosuggest').val('')
    $('.autosuggest_target').val('')

    false
