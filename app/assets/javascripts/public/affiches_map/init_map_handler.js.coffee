@init_affiches_map = () ->
  $(".show_map_link").live 'click', (event) ->
    init_modal_affiche_yandex_map $(this)
    false

  true
