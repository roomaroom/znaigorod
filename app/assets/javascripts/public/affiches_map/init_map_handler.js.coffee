@init_affiches_map = () ->
  $(".show_map_link").live 'click', (event) ->
    yaCounter14923525.reachGoal('affiche_address_click') if $(this).closest('.affiche').length
    init_modal_affiche_yandex_map $(this)
    false

  true
