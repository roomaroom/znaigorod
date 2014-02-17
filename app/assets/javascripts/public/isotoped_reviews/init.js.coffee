@initIsotopedReviews = ->
  list = $('.posters')

  list.isotope
    itemSelector: ".item"
    masonry:
      columnWidth: 380

  list.infinitescroll
    itemSelector: ".item"
    navSelector: "nav.pagination"
    nextSelector: "nav.pagination span.next a"

    , (newElements) ->
      $newElems = $(newElements).css(opacity: 0)

      $newElems.imagesLoaded ->
        $newElems.animate opacity: 1
        list.isotope "appended", $newElems

        return
      return

