@init_common = () ->

  $('a.disabled').live "click", ->
    if $(this).parent('li').hasClass('disabled')
      true
    else
      false

  $('.content .tabs .info .description table tr').each (index, item) ->
    td = $('td:first', this)
    td.text(td.text().squish() + ':') if !td.text().match(/:$/) && td.text() != ""
    true

  $('.ui-widget-overlay').live 'click', ->
    $(this).css('cursor', 'pointer')
    $(this).siblings('.ui-dialog').find('.ui-dialog-content').dialog('close')
    true

  true

randomize = (number) ->
  Math.floor(Math.random() * Math.round(number) + 1)

String.prototype.trim = () ->
  this.replace(/^\s+|\s+$/g, "")

String.prototype.squish = () ->
  this.replace(/\s+/g, " ").trim()

String.prototype.strip_tags = () ->
  this.replace(/(<([^>]+)>)/ig, "").replace(/&\w+;/ig, " ").replace(/&#?[a-z0-9]+;/ig, "")
