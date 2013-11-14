@init_offer_price = ->
  $('.offer_price').on 'ajax:success', ->
    console.log '11'
