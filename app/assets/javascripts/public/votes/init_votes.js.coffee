@init_votes = () ->
  link = $('.votes_wrapper .user_like a').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target).closest('.votes_wrapper')
    target.html(jqXHR.responseText)
    init_auth()
    cloud_handler()
    init_votes()
