# pagination
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
    last_item = first_item.siblings().last()
  else
    last_item = first_item
  last_item_top = last_item.position().top

  last_item_offset = 200


  true

window_scroll_init = () ->
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
          last_item_top = last_item.position().top
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
  , 5000
  true

  # меняем статус сообщения кликом на ссылку, обновляем счетчики не прочитанных сообщений
  $('a.change_message_status.unread').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    target.closest('li').replaceWith(response)
    init_messages_counters(response)

  true

# Получеам из респонса дата-атрибуты для обновления счетчиков не прочитанных сообщений
# для диалогов, приглашений, уведомлений и общего счетчика не прочитанных сообщений
@init_messages_counters = (response) ->
  counter = $(response).data('counter')
  messages = $(response).data('messages')
  dialog_counter = $(response).data('dialog_counter')
  invite_counter = $(response).data('invite_counter')
  notification_counter = $(response).data('notification_counter')

  link = $('.header .messages a')

  if counter == 0
    link.addClass('empty').removeClass('new').attr('title','Нет новых сообщений').html(messages)
  else
    link.addClass('unread').removeClass('empty').attr('title','Есть новые сообщения').html("+#{counter}")

  notification = $('#messages_filter a.notifications')
  if notification_counter == 0
    notification.html('Уведомления')
  else
    notification.html("Уведомления +#{notification_counter}")

  dialog = $('#messages_filter a.dialogs')
  if dialog_counter == 0
    dialog.html('Диалоги')
  else
    dialog.html("Диалоги +#{dialog_counter}")

  invite = $('#messages_filter a.invites')
  if invite_counter == 0
    invite.html('Приглашения')
  else
    invite.html("Приглашения +#{invite_counter}")

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

# AJAX для табов #dialogs, #invites, #notifications
@init_messages = () ->
  # скрол в форме при открытии диалога
  scroll = (target) ->
    y_coord = Math.abs(target[0].scrollHeight)
    target.animate({ scrollTop: y_coord }, 'fast')

  $('#messages_filter').on "tabsselect", (event, ui) ->
    if ui.panel.id == 'dialogs'
      window_scroll_init()
    else
      $(window).unbind('scroll')
      # bad way
      setTimeout () ->
        scroll($('ul.dialog', '#' + ui.panel.id))
      , 100

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

    # пересчет счетчиков
    init_messages_counters(response)

    scroll($('ul.dialog', "#dialog_#{account_id}"))

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



  # загрузка открытых табов при перезагрузке страницы
  load_tabs_handler = (stored) ->
    stored.each (index) ->
      $("ul.dialogs a.dialog_#{index}").click()

  stored = JSON.parse(window.localStorage.getItem('dialogs')) || []

  dialog_click_handler()


  load_tabs_handler(stored)


  # таб диалоги
  $('#dialogs').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if target.hasClass('to_dialog')
      add_tab_handler(response, stored)
      close_tab_handler(stored)

    if target.hasClass('simple_form new_private_message')
      account_id = $(response).closest('li').data('account_id')

      $('ul.dialog', "#dialog_#{account_id}").append(response)
      $('.private_message textarea').attr("value", "")
      scroll($('ul.dialog', "#dialog_#{account_id}"))

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

      # пересчет счетчиков
      init_messages_counters(response)

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

    # пересчет счетчиков
    init_messages_counters(response)

  true

  # личное сообщение
  $('#messages_filter').on 'ajax:success', (evt, response) ->
    target = $(evt.target)

    if target.hasClass('simple_form new_private_message')
      account_id = $(response).closest('li').data('account_id')

      $('ul.dialog',  "#dialog_#{account_id}").append(response)
      $('.private_message textarea').attr("value", "")
      scroll($('ul.dialog', "#dialog_#{account_id}"))
  true
