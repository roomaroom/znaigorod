@init_list_settings = () ->
  unless $.cookie
    console.error "$.cookie() is not a function. please include it" if console && console.error
    return false
  $.cookie.defaults =
    path: "/"
    expires: 365
  list_settings = {}
  unless $.cookie("znaigorod_list_settings")
    list_settings =
      sort: []
      aspect: ""
    $(".content_wrapper .list_settings .sort ul li").each (index, item) ->
      klass = $('a', item).attr("class")
      list_settings.sort.push(klass.replace("selected", "").trim()) if klass.match(/selected/)
    aspect = $(".content_wrapper .list_settings .aspect ul li .selected")
    list_settings.aspect = aspect.attr("class").replace("selected", "").trim()
    $.cookie "znaigorod_list_settings", JSON.stringify(list_settings)
  else
    list_settings = JSON.parse($.cookie("znaigorod_list_settings"))
  true
