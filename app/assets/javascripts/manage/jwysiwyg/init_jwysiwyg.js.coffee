@init_jwysiwyg = () ->
  textareas =  $('.need_editor')
  textareas.wysiwyg
    iFrameClass: 'jwysiwyg_editor'
    plugins:
      i18n:
        lang: 'ru'
    controls:
      indent:               { visible : false }
      outdent:              { visible : false }
      subscript:            { visible : false }
      superscript:          { visible : false }
      insertHorizontalRule: { visible : false }
      insertImage:          { visible : false }
      code:                 { visible : false }
      html:                 { visible : true }
