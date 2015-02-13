@init_sortable = ->

  recalculate_posotion = (wrapper) ->
    $('li input.position', wrapper).each (index, item) ->
      $(item).val index+1
      $('span.position', $(item).closest('li')).text index+1
      true
    true

  wrapper = $('.sortable')

  wrapper.sortable
    axis: 'y'
    containment: 'parent'
    handle: '.sortable_handle'
    items: 'li'
    stop: (event, ui) ->
      recalculate_posotion(ui.target)
      if wrapper.data('sort')
        $.ajax
          url: wrapper.data('sort')
          type: 'POST'
          data: wrapper.serialize()
          error: (jqXHR, textStatus, errorThrown) ->
            response = $("<div>#{jqXHR.responseText}</div>")
            $('meta', response).remove()
            $('title', response).remove()
            $('style', response).remove()
            console.error response.html().trim() if console && console.error
            true
          success: (data, textStatus, jqXHR) ->
            wrapper.effect 'highlight', 1500
            true

      true

  return
