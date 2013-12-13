@init_contest = () ->

  $('#contest_og_image').on 'change', ->
    $(this).parents('form').submit()
    true

  true
