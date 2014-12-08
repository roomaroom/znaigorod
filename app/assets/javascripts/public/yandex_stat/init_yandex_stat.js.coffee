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

@init_potential_banner_stat = () ->
  $('.js-stat-potential').click ->
    yaCounter14923525.reachGoal('potential_banner') if yaCounter14923525?
    true

  return

@init_krasavitsa_banner_stat = () ->
  $('.js-stat-krasavitsa-2014').click ->
    yaCounter14923525.reachGoal('krasavitsa_2014_banner') if yaCounter14923525?
    true

  return

@init_top_banner_stat = () ->
  $('.top_headline a').click ->
    yaCounter14923525.reachGoal('top_banner') if yaCounter14923525?
    true

  return
