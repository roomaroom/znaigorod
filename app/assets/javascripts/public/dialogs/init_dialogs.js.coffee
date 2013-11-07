init_dialog_pagination = (id) ->
  busy = false
  $('#' + id).css
    overflow: 'auto'

  $('#messages_filter .dialog').each (el) ->
    if $(this).data('jsp')
      $(this).data('jsp').destroy()

  tab = $("##{id} .dialog")
  pagination = $('.pagination', tab)
  pagination.css
    display: 'none'
  next_link = $('.next a', pagination)

  tab.jScrollPane
    verticalGutter: 0
    showArrows: true
    mouseWheelSpeed: 30

  scroll = tab.data('jsp')
  unless scroll == undefined
    setTimeout () ->
      scroll.reinitialise()
      scroll.scrollToY($('.jspPane', tab).height())
      if next_link.length
        tab.bind 'jsp-scroll-y', (event, scrollPositionY, isAtTop, isAtBottom) ->
          block_offset = $('.jspPane', tab).height() - ($('.jspPane', tab).height() * 0.7)
          if scrollPositionY < block_offset && !busy && next_link.attr('href') != undefined && scrollPositionY != 0
            busy = true
            $.ajax
              url: next_link.attr('href')
              success: (response, textStatus, jqXHR) ->
                return true if (typeof next_link.attr('href')) == undefined
                pagination.remove()
                $('.jspPane', event.target).prepend('<div id="dialogs-hidden-block" style="display: none">' + response + '</div>')

                hidden_block = $('#dialogs-hidden-block')
                hidden_block_height = hidden_block.height()
                hidden_block.remove()
                $('.jspPane', event.target).prepend(response)

                $('.pagination', tab).css
                  display: 'none'
                next_link = $(response).last().find('.next a')

                scroll.reinitialise()
                scroll.scrollToY(hidden_block_height + scroll.getContentPositionY() - 28)
                busy = false
                true
            true
        true
      true
    , 100
  true

# pagination for dialogs
page = 1
busy = false
list_url = ""
list = ""
first_item = ""
last_item = ""
last_item_top = ""
last_item_offset = ""

@init_pagination_dialogs = () ->

  $('body nav.pagination').css
    'height': '0'
    'visibility': 'hidden'
  list_url = window.location.pathname
  list = $(
    '#dialogs .dialogs'
  )
  first_item = $('li:first', list)
  return true unless first_item.length
  if first_item.siblings().length
    last_item = $('li:last', list)
  else
    last_item = first_item
  last_item_top = last_item.position().top

  last_item_offset = 200


  true

window_scroll_init = () ->
  if $('#dialogs').length
    $(window).scroll ->
      if ($(this).scrollTop() + $(this).height()) >= (last_item_top - last_item_offset) && !busy
        busy = true
        search_params = ""
        search_params = window.location.search.replace(/^\?/, "&").replace(/&page=\d+/, "")

        $.ajax
          url: "#{list_url}?page=#{parseInt(page) + 1}#{search_params}"
          beforeSend: (jqXHR, settings) ->
            $('<li class="ajax_loading_items_indicator">&nbsp;</li>').appendTo(list)
            true
          complete: (jqXHR, textStatus) ->
            $('li.ajax_loading_items_indicator', list).remove()
            true
          success: (data, textStatus, jqXHR) ->
            return true if data.trim().isBlank()
            list.append(data)
            last_item = first_item.siblings().last()
            last_item_top = $('li:last', list).position().top
            page += 1
            busy = false unless data.trim().isBlank()
            dialog_unbind()
            dialog_click_handler()
            true

    true


# Меняем статус сообщения на прочитанное, каждый раз как видим не прочитанное сообщение ('unread')
@process_change_message_status = () ->
  timer = setInterval ->
    target = $('a.change_message_status.unread:first', '#dialogs:visible, #invites:visible, #notifications:visible, .dialog:visible')
    if target.length
      target.click()
    else
      clearInterval(timer)
  , 1000
  true

  # меняем статус сообщения кликом на ссылку
  $('a.change_message_status.unread').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    target.closest('li').replaceWith(response)

  true

# Табы jQuery-UI
@init_messages_tabs = () ->
  $('#messages_filter').tabs
    create: (event, ui) ->
      if window.location.hash == '#to_invites'
        $('#messages_filter').tabs('select', '#invites')
        window.location.hash = ''
      true
    show: (event, ui) ->
      process_change_message_status()
      true


# actions which are happend when somebody click to dialogs
dialog_click_handler = () ->
  $('.to_dialog').on 'click', ->
    block_id = $(this).attr('class').match(/dialog_\d+/)
    $('#messages_filter').tabs("select", '#'+block_id)

    $(this).closest('li:not(.invite_message_list)').addClass('read').removeClass('unread')

    true

  $('#dialogs ul.dialogs > li').each (index, item) ->
    $(this).on 'click', (event) ->
      $('a.to_dialog', $(event.target).closest('li')).click() unless $(event.target).is('a')
      true
    true

  $('.to_dialog').on 'ajax:beforeSend', (xhr, settings) ->
    return false if $(this).hasClass('disabled')
    $('.'+$(this).attr('class').match(/dialog_\d+/), '#messages_filter').addClass('disabled')
    true

  true

# unbind all dialog actions
dialog_unbind = () ->
  $('.to_dialog').unbind()

  $('#dialogs ul.dialogs > li').each (index, item) ->
    $(this).unbind()
    true

  true

add_disabled = () ->
  tabs = $('.ui-state-default.ui-corner-top a')
  for tab in tabs
    href = tab.href.split('/').last()
    unless href == '#dialogs'
      $(href.replace('#', '.')).addClass 'disabled'
  true

# AJAX для табов #dialogs, #invites, #notifications
@init_messages = () ->

  $('#messages_filter').on "tabsselect", (event, ui) ->
    if ui.panel.id == 'dialogs'
      $.ajax
        url: "my/dialogs"
        success: (data, textStatus, jqXHR) ->
            $('#dialogs').find('.dialogs').html(data)
            window_scroll_init()
            init_back_to_top()
            dialog_unbind()
            dialog_click_handler()
            add_disabled()
            true
          true
    else
      $(window).unbind('scroll')
      init_dialog_pagination(ui.panel.id)

  # обработка открытия нового таба для диалога
  add_tab_handler = (response, stored) ->
    account = $(response).data('account')
    account_id = $(response).data('account_id')

    $('#messages_filter').tabs
      tabTemplate: "<li><a href='\#{href}\'><span class='with_close'>\#{label}\</span></a><span class='ui-icon ui-icon-close ui-corner-all close'>x</span></li>"
    $('#messages_filter').tabs "add", "#dialog_#{account_id}", "#{account}"
    $("#dialog_#{account_id}").append(response)
    $('#messages_filter').tabs "select", "#dialog_#{account_id}"

    stored.push(account_id) if stored.indexOf(account_id) < 0
    window.localStorage.setItem("dialogs", JSON.stringify(stored))

    # меняем статус сообщений на прочитанные в табе #dialogs
    process_change_message_status()

    #scroll($('ul.dialog', "#dialog_#{account_id}"))

  # обработка закрытия таба
  close_tab_handler = (stored) ->
    close_buttons = $('#messages_filter span.ui-icon-close:not(.charged)')
    close_buttons.each (index, item) ->
      $(item).addClass('charged').live 'click', (evt) ->
        target = $(evt.target)

        dialog_id = $(target.siblings('a').attr('href'))
        account_id = target.siblings('a').attr('href').replace('#dialog_', '')
        link = target.siblings('a').attr('href').replace('#', '.')

        $(link, '#messages_filter').removeClass('disabled')

        dialog_id.remove()
        target.closest('li').remove()

        $('#messages_filter').tabs "select", "#dialogs"

        index = stored.indexOf(account_id)
        stored.splice(index, 1)
        window.localStorage.setItem("dialogs", JSON.stringify(stored))

        true
    true


  load_hash_dialog = (stored) ->
    hash = window.location.hash.replace('#','')
    if hash != ''
      if $("ul.dialogs a.#{hash}").length
          $("ul.dialogs a.#{hash}").click()
    else
      $.ajax
        url: "my/dialogs/#{hash.replace('dialog_','')}"
        success: (data, textStatus, jqXHR) ->
            add_tab_handler data, stored
            close_tab_handler(stored)
          true
    true

  # загрузка открытых табов при перезагрузке страницы
  load_tabs_handler = (stored) ->
    hash = window.location.hash.replace('#','')
    count = stored.length

    if count == 0
      load_hash_dialog(stored)

    stored.each (index) ->
      $("ul.dialogs a.dialog_#{index}").click() unless "#{index}" == hash.replace('dialog_','')
      count--
      if count == 0
        load_hash_dialog(stored)

    $(document).ready(window_scroll_init())

    true

  stored = JSON.parse(window.localStorage.getItem('dialogs')) || []

  dialog_click_handler()

  load_tabs_handler(stored)

  # таб диалоги
  $('#dialogs').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if target.hasClass('to_dialog')
      add_tab_handler(response, stored)
      close_tab_handler(stored)

  true

  # таб приглашения
  $('#invites').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if target.hasClass('to_dialog')
      add_tab_handler(response, stored)
      close_tab_handler(stored)

    if target.hasClass('agreement')
      invite_counter = $(response).data('invite_counter')

      target.closest('li').replaceWith(response)

  true


  # таб уведомления
  $('#notifications').on 'ajax:success', (evt, response) ->
    target = $(evt.target)

    target.closest('li').replaceWith(response)
    wrapper = $('<div/>')
    wrapper.html(response)
    klass = $('li', wrapper).attr('class').replace('ajax_message_status', '').replace('unread', '').replace('read', '').compact()
    $("#notifications .#{klass}").removeClass('unread').addClass('read')
    wrapper.remove()

  true

  # личное сообщение
  $('#messages_filter').on 'ajax:success', (evt, response) ->
    target = $(evt.target)

    if target.hasClass('simple_form') && target.hasClass('new_private_message')
      account_id = $(response).closest('li').data('account_id')
      last = $('ul.dialog li:last', "#dialog_#{account_id}")
      unless $(response).attr('id') == 'new_private_message'
        if last.length
          last.after(response)
        else
          $('ul.dialog').find('.jspPane').append(response)

      init_dialog_pagination("dialog_#{account_id}")
      $('.private_message textarea').attr("value", "")
      #scroll($('ul.dialog', "#dialog_#{account_id}"))
  true
