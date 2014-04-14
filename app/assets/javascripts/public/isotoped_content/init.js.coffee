@initIsotopedContent = ->
  list = $('.js-isotoped-content')

  columnWidth = list.data('item-width')

  $container = list.isotope
    itemSelector: '.item'
    masonry:
      columnWidth: columnWidth

  # пагинация по нажатию на кнопку для афиш
  if $('.js-paginable-list').length
    page = 2

    paginator = $('.js-next-page')

    paginator.on 'ajax:beforeSend', (xhr, settings) ->
      return false if $(this).hasClass('disabled')

      $(this).addClass('disabled').html('Загружаю...')

    paginator.on 'ajax:success', (evt, response, status, xhr) ->
      if $(response).length
        elms = $(response)
        $container.append(elms).isotope( 'appended', elms)

        url = paginator.attr('href').replace(/page=\d/, "page=#{page += 1}")
        paginator.attr('href', url)

        paginator.removeClass('disabled').html('Еще события')

      else
        $('.pagination').remove()

  # пагинация с бесконечным скролом для обзоров
  if $('.reviews_index').length
    list.infinitescroll
      itemSelector: ".item"
      navSelector: "nav.pagination"
      nextSelector: "nav.pagination span.next a"
      loading:
        msgText: ''
        finishedMsg: ''
        img: '/assets/public/ajax_loading_items_indicator.gif'

      , (newElements) ->
        $newElems = $(newElements).css(opacity: 0)

        # просмотр видео в окне для постов приехавших со следующих страниц
        initReviewVideoPreview()

        $newElems.imagesLoaded ->
          $newElems.animate opacity: 1
          list.isotope "appended", $newElems

          return
        return

