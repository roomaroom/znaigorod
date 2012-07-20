@init_galleria = () ->
  $('.gallery_container').galleria
    autoplay: 7000
    easing: 'galleriaIn'
    imageCrop: 'landscape'
    preload: 3
    showCounter: false
    showFullscreen: true
    showInfo: true
    _toggleInfo: false
    thumbnails: false
    thumbCrop: true
    transition: 'slide'
    transitionSpeed: 500
    width: 850

  Galleria.ready ->
    galleria = this
    count_images = galleria._thumbnails.length
    frames_nav = $('<div />', { class: 'galleria-frames' }).insertAfter('.galleria-info')

    i = 0
    while i < count_images
      frames_nav.append('<div class="frame_item" id="frame_'+i+'" />')
      i++

    frames_nav.find('.frame_item').on 'click', ->
      $this = $(this)
      index = $this.attr('id').replace('frame_', '') - 0
      galleria.show(index)

    galleria.bind 'image', (e) ->
      frames_nav.find('.active').removeClass('active')
      frames_nav.find('#frame_'+e.index).addClass('active')

