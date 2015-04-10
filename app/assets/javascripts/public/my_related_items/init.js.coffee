@loadRelatedAfishas = ->
  need_empty = false

  getRelatedItems = ->
    relatedItems=[]
    $('.hidden_ids').each ->
      relatedItems.push $(this).val()
    relatedItems

  getAjaxUrl = ->
    ajax_url = $('.type_select option:selected').val() || '/my/related_organizations'

  getSearchParam = ->
    searchParam = $('.related_search').val()

  just_one = ->
    return true if $('.js-just-one').length
    return false

  performAjax = ->
    $.ajax
      type: 'get'
      url: getAjaxUrl()
      data:
        related_items_ids: getRelatedItems()
        search_param: getSearchParam()
      success: (response) ->
        $('.posters').empty() if need_empty
        $('.posters').append(response)
        $('.posters').find('button').prop('disabled', true) if $('.element').length && just_one()
        #$('.posters').infinitescroll('destroy')
        #$('.posters').data('infinitescroll', null)
        #initInfiniteScroll()
    false

  # on page load
  performAjax()

  $('body').on 'click', '.js-button-add-related-item', ->
    url = $(this).closest('.details').find('a')
    item_id = $(this).closest('.details').find('#hidden_id').val()
    params_name = $('.relations').find('.params_name').val()
    $(this).prop('disabled', true).text('Добавлено')
    $('.sticky_elements').append('<div class="element">
                                  <a href="' + url.attr('href') + '">' + url.text()  + '</a>
                                  <span class="del_icon"></span>
                                  <input name="'+params_name+'" type="hidden" value="' + item_id  + '" class="hidden_ids">
                                </div>')
    $('.posters').find('button').prop('disabled', true) if just_one()

    return

  $('body').on 'click', '.del_icon', ->
    $('input[value="'+$(this).parent().find('.hidden_ids').val()+'"]').closest('div').find('button').prop('disabled', false).text('Добавить')
    $(this).closest(".element").remove()

    $('.posters').find('button').prop('disabled', false) if just_one()

    return

  $('.type_select').change ->
    need_empty = true
    performAjax()

  $('.sbm').click ->
    need_empty = true
    performAjax()

  $('.related_search').keyup ->
    need_empty = true
    performAjax()

#initInfiniteScroll = ->
  #$('.posters').infinitescroll
    #behavior: 'local'
    #binder: $('.posters')
    #debug: false
    #itemSelector: ".poster"
    #maxPage: $('nav.pagination').data('count')
    #navSelector: "nav.pagination"
    #nextSelector: "nav.pagination span.next a"
    #pixelsFromNavToBottom: ($(document).height() - $('.posters').scrollTop() - $(window).height()) - $('.posters').height()
    #bufferPx: 500
    #loading:
      #finishedMsg: ''
      #msgText: ''
