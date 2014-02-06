@initPromoteAfisha = ->
  $('.promoted_link').on 'ajax:success', ->
    $(this).text('приподнялось!').animate
      backgroundColor: '#9fdba1'
      color: '#fff'
      500

