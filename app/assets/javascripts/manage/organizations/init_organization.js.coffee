@init_organization = () ->

  $('.new_section_link').click ->
    $('.new_section').toggle()
    false

  $('.new_section_button').click ->
    $.ajax
      type: "GET"
      data:
        section_title: $('#new_section').val()
      success: ->
        $('.sections').append("
          <p>" + $('#new_section').val()  + "</p>
          ")
        $('.new_section').toggle()
  true

