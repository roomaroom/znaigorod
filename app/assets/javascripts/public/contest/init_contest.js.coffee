@init_contest = () ->
  toggler =  $('.content_wrapper .contest .toggler a')
  toggable =  $('.content_wrapper .contest .toggable')
  if toggler.length && toggable.length
    toggler.toggleClass('closed')
    toggler_html = toggler.html()
    toggler.html(toggler_html.add(' &darr;'))
    toggler.click (event) ->
      toggler.toggleClass('closed')
      if toggler.hasClass('closed')
        toggable.slideUp 'fast', ->
          toggler.html(toggler_html.add(' &darr;'))
          true
      else
        toggable.slideDown 'fast', ->
          toggler.html(toggler_html.add(' &uarr;'))
      false
  true

  if typeof VK != 'undefined'
    if $('#vk_contest_work_like').length
      page_title = $('h1', $('#vk_contest_work_like').closest('.content_wrapper')).text().compact() +
        '. ' + $('h2', $('#vk_contest_work_like').closest('.contest .work')).text().compact()
      page_image = $('.image img', $('#vk_contest_work_like').closest('.contest .work')).attr('src').replace(/\/\d+-\d+\//, '/100-63!n/')
      page_description = $('.author', $('#vk_contest_work_like').closest('.contest .work')).text().compact()
      if $('.description', $('#vk_contest_work_like').closest('.contest .work')).length
        page_description += '. ' + $('.description', $('#vk_contest_work_like').closest('.contest .work')).text().compact()
        page_description = page_description.first(137) + '...'
      else
        page_description = page_description.first(140)
      VK.Widgets.Like 'vk_contest_work_like',
        type: 'button'
        height: '20'
        pageTitle: page_title
        pageImage: page_image
        pageDescription: page_description
        text: page_description
      true
    if $('#vk_contest_work_comments').length
      VK.Widgets.Comments 'vk_contest_work_comments'
        limit: '10'
        width: '980'
        attach: '*'
      true
