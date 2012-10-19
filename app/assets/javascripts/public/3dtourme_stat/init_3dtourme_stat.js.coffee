@init_3dtourme_stat = () ->
  link = $('a.3dtourme')
  link.click (event) ->
    yaCounter14923525.reachGoal("3dtourme") unless link.hasClass("development")
    true
  true
