@init_filter_checker = () ->
  filters = $('.filters')

  $('.by_affiche_categories li a, .by_organization_categories li a, .by_tag li a, .by_cuisine li a, .by_offer li a, .by_feature li a, .by_payment li a').click ->
    $(this).toggleClass('active')
    filters.trigger('changed')

    false
