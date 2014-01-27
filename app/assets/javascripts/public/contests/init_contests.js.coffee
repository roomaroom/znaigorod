@init_contests = () ->
  $.scrollTo($('.contest .work'), 500, { offset: {top: -20} })
  true

@init_contest_agreement = () ->
  $('.agreement_link').on 'click', ->
    $('.agreement_text').fadeToggle()

    false
