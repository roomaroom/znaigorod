@initMyQuestions = ->
  initMarkitup()
  handleImageButtonClick()

  form = $('.my_review_form')

  textInputs = $('#question_title, .with-preview')
  tagsInput = $('#question_tag')

  textInputs.on 'keyup', ->
    delay (->
      form.trigger('preview')
    ), 1000

  tagsInput.on 'change', ->
    delay (->
      form.trigger('preview')
    ), 1000

  form.on 'preview', ->
    serialized = $('input[name!=_method], textarea', form)
    $.post('/my/questions/preview', serialized)
      .done (data) ->
        $('.reviews_show').html(data)

  $('.tagit_categories').tagit {
    fieldName:        'categories',
    allowDuplicates:  false,
    readOnly:         true,
    placeholderText:  ''
    beforeTagAdded: (event, ui) ->
      if ui.tagLabel == 'Выберите категорию'
        return false

  }

  $('.select_type').change ->
    $('.tagit_categories').tagit('createTag', $('.select_type option:selected').text())
    $('.select_type').val($('.select_type option:first').val())

initMarkitup = ->
  $('.markitup').markItUp(markItUpSettings())
