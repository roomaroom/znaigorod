@init_organization_jump_to_afisha = ->
  $('.organization_show .afisha_details .presentation_filters .order_by a').click ->
    $.cookie('_znaigorod_jump_to_afisha', true)
    true

  if $.cookie('_znaigorod_jump_to_afisha')
    setTimeout ->
      $.scrollTo $('.organization_show .afisha_details'), 500, { offset: {top: -50} }
      $.removeCookie('_znaigorod_jump_to_afisha')
    , 500

  true

  $('.organization_show .discount_details .presentation_filters .order_by a').click ->
    $.cookie('_znaigorod_jump_to_discounts', true)

  if $.cookie('_znaigorod_jump_to_discounts')
    setTimeout ->
      $.scrollTo $('.organization_show .discount_details'), 500, { offset: {top: -50} }
      $.removeCookie('_znaigorod_jump_to_discounts')
    , 500

  $('.js-show-phone').click ->
    $.ajax
      url: "/show_phone"
      type: "GET"
      data:
        organization_id: $(this).attr('id')
      success: (response) ->
        $('.phone_wrapper').empty()
        $('.phone_wrapper').append(response)
        $('.phone_wrapper').append('     Скажите, что Вы нашли телефон на ЗнайГород')
      done:
        $(this).remove()

