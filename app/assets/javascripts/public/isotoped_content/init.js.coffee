@initIsotopedContent = ->
  list = $('.js-isotoped-content')

  columnWidth = list.data('item-width')

  $container = list.isotope
    itemSelector: '.item'
