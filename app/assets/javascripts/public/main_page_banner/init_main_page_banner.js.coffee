@init_main_page_banner = () ->
  banner = $('.main_page_block .affiche')
  previews = $('.previews', banner)
  poster = $('.poster', banner)

  banner_rotate = ->
    clearTimeout timeout

    previews.css bottom: 0
    previews.animate
      bottom: -height
    , 600
    previews.children().last().prependTo previews
    $myclone = previews.children().last().clone()
    image_manipulation = $myclone.html()
    console.log image_manipulation
    $big_image = image_manipulation.replace(/files\/(\d+)\/\d+-\d+(\!|%21)/,'files/$1/653-363!')
    poster.html $big_image
    poster.find('img').removeClass("min").addClass "max"
    poster.find('img').css(opacity: 0).animate
      opacity: 1
    , 600

    timeout = setTimeout(->
      banner_rotate()
    , 10000)

  height = previews.find('li').outerHeight(true) + 1
  timeout = 0

  banner_rotate()
