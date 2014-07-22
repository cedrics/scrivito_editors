$ ->
  # This file integrates contenteditable for string attributes.

  onKey = (event) ->
    cmsField = $(event.currentTarget)
    key = event.keyCode || event.which

    switch key
      when 13 # Enter
        event.preventDefault()
        cmsField.blur()
      when 27 # Esc
        event.stopPropagation()
        cmsField.blur()

  onInput = (event) ->
    cmsField = $(event.currentTarget)
    save(cmsField, false)

  onBlur = (event) ->
    cmsField = $(event.currentTarget)

    save(cmsField, true).done ->
      if cmsField.attr('data-reload') == 'true'
        cmsField.trigger('scrivito_reload')

  save = (cmsField, andClose) ->
    cleanUp(cmsField)

    clone = cmsFieldAndPastedContent(cmsField).clone()
    clone.find('br').replaceWith('\n')
    content = clone.text()
    clone.remove()

    if andClose
      cmsField.text(content)

    # Save only if the content has changed.
    if content != cmsField.scrivito('content')
      cmsField.scrivito('save', content).done ->
        cmsField.trigger('save.scrivito_editors')
    else
      $.Deferred().resolve()

  cleanUp = (cmsField) ->
    siblings = cmsFieldAndPastedContent(cmsField)
    pasted = siblings.not(cmsField)
    if pasted.length > 0
      pasted.remove()
      cmsField.text(siblings.text())

  cmsFieldAndPastedContent = (cmsField) ->
    cmsField.siblings().addBack().not(cmsField.data('siblings_before_edit'))

  initialize = ->
    $('body').on 'mouseenter', '[data-scrivito-field-type="string"]:not([data-editor]), [data-editor~="string"]', (event) ->
      cmsField = $(event.currentTarget)

      unless cmsField.attr('contenteditable')?
        cmsField
          .data('siblings_before_edit', cmsField.siblings())
          .attr('contenteditable', true)
          .blur(onBlur)
          .keypress(onKey)
          .keyup(onKey)
          .on('input', onInput)

    # Prevent editable link strings to follow the link target on click.
    $('body').on 'click', '[data-scrivito-field-type="string"]:not([data-editor]), [data-editor~="string"]', (event) ->
      event.preventDefault()

  scrivito.on 'load', ->
    if scrivito.in_editable_view()
      initialize()
