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
