@init_organization = () ->
  $('.new_section_link').click ->
    $('.new_section').toggle()
    false

  $('.new_section_button').click ->
    $.ajax
      type: "GET"
      data:
        section_title: $('#new_section').val()
      success: (response) ->
        $('.sections ul').append("
          <li><a href='/manage/organizations/"+response.organization+"/sections/"+response.id+"'>" + $('#new_section').val()  + "</a></li>
          ")
        $('.new_section').toggle()
        $('#new_section').val('')

  true

@init_organization_form = () ->
  $('.js-open-list').click ->
    $(this).parent().parent().next('.children').toggleClass('opened closed')
    false

  $('.js-root').change ->
    root = $(this)[0]
    children = $(this).parent().next('.children').find('input')

    children.each (index, item) ->
      item.checked = root.checked
      true

    false
  true

@initMarkitup = ->
  $('.markitup').markItUp(markItUpSettings())
  handleImageButtonClick()

markItUpSettings = ->
  settings = clone(mySettings)

  imageButton = {
    name:'Изображение'
    className: 'image_button'
    openWith: ''
    beforeInsert: (h) ->
      beforeImageInsert(h)
  }

  youtubeButton = {
    name: 'Видео с Youtube'
    className: 'youtube_button'
    replaceWith: '[![Добавление видео с Youtube:!:Просто вставьте сюда ссылку на видео с Youtube, например, http://www.youtube.com/watch?v=e-GYrbecb88]!]'
  }

  vimeoButton = {
    name: 'Видео с Vimeo'
    className: 'vimeo_button'
    replaceWith: '[![Добавление видео с Vimeo:!:Просто вставьте сюда ссылку на видео с Vimeo, например, http://vimeo.com/11192521]!]'
  }

  buyButton = {
    name: 'Добавить ссылку "Купить"'
    className: 'buy_button'
    replaceWith: "<div align='center' class='buy_button'> <a class='button payment_link' href='http://znaigorod.ru/discounts/#{get_discount_slug().responseText}/copy_payments/new'>[![Текст кнопки:!:Введите текст кнопки]!] </a> </div>"
  }

  settings.markupSet.push(imageButton)
  settings.markupSet.push(youtubeButton)
  settings.markupSet.push(vimeoButton)
  settings.markupSet.push(buyButton) if $('.discounts').length && $('form.simple_form').attr('class').indexOf('edit') > -1

  settings

get_discount_slug = ->
  $.ajax
    type: 'get'

@handleImageButtonClick = ->
  $('.image_button').click ->
    $('#gallery_image_file').focus().trigger('click')

beforeImageInsert = (h) ->
  textarea = $(h.textarea)

  before = textarea.val()[0...h.caretPosition]
  after = textarea.val()[(h.caretPosition + h.selection.length)...textarea.val().length]

  file_input = $('.upload_gallery_images #gallery_image_file')

  file_input.fileupload
    dataType: 'json'

    done: (e, data) ->
      url = data.result.files[0].url
      textarea.val("#{before}!#{url}!#{after}")
      textarea.trigger('preview')

    start: (e) ->
      top = $(document).scrollTop()
      $('body').addClass('non_scrollable')

      $('.loader').show().offset
        left: 0
        top: top

    stop: (e) ->
      $('body').removeClass('non_scrollable')
      $('.loader').hide()

    fail: (e, data) ->
      message = data.jqXHR.responseText
      $('.message_wrapper').text(message).show().delay(5000).slideUp('slow')
