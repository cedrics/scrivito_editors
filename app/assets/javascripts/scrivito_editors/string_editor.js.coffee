$ ->
  # This file integrates contenteditable for string attributes.

  timeout = undefined

  onKey = (event) ->
    if timeout?
      clearTimeout(timeout)

    cmsField = $(event.currentTarget)
    key = event.keyCode || event.which

    switch key
      when 13 # Enter
        event.preventDefault()
        cmsField.blur()
      when 27 # Esc
        if event.type == 'keyup'
          event.stopPropagation()
          cmsField
            .off('blur')
            .trigger('scrivito_reload')
      else
        setTimeout ->
          cleanUp(cmsField)

        timeout = setTimeout ( ->
          save(cmsField, false)
        ), 3000

  onBlur = (event) ->
    cmsField = $(event.currentTarget)

    save(cmsField, true).done ->
      if cmsField.attr('data-reload') == 'true'
        cmsField.trigger('scrivito_reload')

  save = (cmsField, andClose) ->
    if timeout?
      clearTimeout(timeout)

    cleanUp(cmsField)

    clone = cmsFieldAndPastedContent(cmsField).clone()
    clone.find('br').replaceWith('\n')
    content = clone.text()
    clone.remove()

    if andClose
      cmsField.text(content)

    cmsField.scrivito('save', content)

  cleanUp = (cmsField) ->
    siblings = cmsFieldAndPastedContent(cmsField)
    pasted = siblings.not(cmsField)
    if pasted.length > 0
      pasted.remove()
      cmsField.text(siblings.text())

  cmsFieldAndPastedContent = (cmsField) ->
    cmsField.siblings().addBack().not(cmsField.data('siblings_before_edit'))

  initialize = ->
    $('body').on 'mouseenter', '[data-scrivito-field-type="string"]:not([data-editor]), [data-editor="string"]', (event) ->
      cmsField = $(event.currentTarget)

      unless cmsField.attr('contenteditable')?
        cmsField
          .data('siblings_before_edit', cmsField.siblings())
          .attr('contenteditable', true)
          .blur(onBlur)
          .keypress(onKey)
          .keyup(onKey)

    # Prevent editable link strings to follow the link target on click.
    $('body').on 'click', '[data-scrivito-field-type="string"]:not([data-editor]), [data-editor="string"]', (event) ->
      event.preventDefault()

  scrivito.on 'editing', ->
    initialize()
