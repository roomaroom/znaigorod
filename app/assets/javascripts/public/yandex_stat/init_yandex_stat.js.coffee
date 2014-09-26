@init_3dtourme_stat = () ->
  link = $('a.3dtourme')
  link.click (event) ->
    yaCounter14923525.reachGoal('3dtourme') if yaCounter14923525?
    true
  true

@init_tickets_stat = () ->
  link_on_list = $('.tickets_list li a.payment_link')
  link_on_list.click (event) ->
    yaCounter14923525.reachGoal('ticket_on_list') if yaCounter14923525?
    true
  link_on_affiche = $('.affiche .tickets a.payment_link')
  link_on_affiche.click (event) ->
    yaCounter14923525.reachGoal('ticket_on_affiche') if yaCounter14923525?
    true
  true

#@init_training_banner_stat = () ->
  #$('div.training').mousedown ->
    #yaCounter14923525.reachGoal('gadecky_training') if yaCounter14923525?
    #true

  #return

@init_love_kiss_hug_banner_stat = () ->
  $('div.love_kiss_hug').click ->
    yaCounter14923525.reachGoal('love_kiss_hug') if yaCounter14923525?
    true

  return

@init_questions_banner_stat = () ->
  $('.top_headline a').click ->
    yaCounter14923525.reachGoal('questions_banner') if yaCounter14923525?
    true

  return

@init_photostream_stat = () ->
  $('.js-yandex-stat-top').click ->
    yaCounter14923525.reachGoal('ohotanasvadbu-top') if yaCounter14923525?
    true

  $('.js-yandex-stat-photo').click ->
    yaCounter14923525.reachGoal('ohotanasvadbu-photo') if yaCounter14923525?
    true

  return

@init_go_go_stat = () ->
  $('.js-go-go-stat').click ->
    yaCounter14923525.reachGoal('dance-go-go') if yaCounter14923525?
    true

  return
