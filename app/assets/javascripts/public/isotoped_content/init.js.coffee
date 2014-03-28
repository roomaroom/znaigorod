@initIsotopedContent = ->
  list = $('.posters')

  columnWidth = list.data('item-width')

  list.isotope
    itemSelector: '.item'
    masonry:
      columnWidth: columnWidth

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
      initReviewVideoPreview() if $('.reviews_index').length

      $newElems.imagesLoaded ->
        $newElems.animate opacity: 1
        list.isotope "appended", $newElems

        return
      return

