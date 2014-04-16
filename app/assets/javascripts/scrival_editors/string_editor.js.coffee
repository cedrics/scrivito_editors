$ ->
  # This file integrates contenteditable for string attributes.

  scrival.on 'editing', ->

    cmsField = undefined
    timeout = undefined

    onKey = (event) ->
      if timeout?
        clearTimeout(timeout)

      if cmsField?
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
                .trigger('scrival_reload')
              cmsField = undefined
          else
            setTimeout(cleanUp)
            timeout = setTimeout ( ->
              save(false)
            ), 3000

    onBlur = (event) ->
      if cmsField?
        field = cmsField

        save(true).done ->
          if field.attr('data-reload') == 'true'
            field.trigger('scrival_reload')

    save = (andClose) ->
      if timeout?
        clearTimeout(timeout)

      cleanUp()
      clone = cmsField.siblings().addBack().not(cmsField.data('siblings_before_edit')).clone()
      clone.find('br').replaceWith('\n')
      content = clone.text()
      clone.remove()
      field = cmsField
      if andClose
        cmsField.text(content)
        cmsField = undefined
      field.scrival('save', content)

    cleanUp = () ->
      siblings = cmsField.siblings().addBack().not(cmsField.data('siblings_before_edit'))
      pasted = siblings.not(cmsField)
      if pasted.length > 0
        pasted.remove()
        cmsField.text(siblings.text())

    $('body').on 'mouseenter', '[data-scrival-field-type="string"]:not([data-editor]), [data-editor="string"]', (event) ->
      field = $(event.currentTarget)

      unless field.attr('contenteditable')?
        field
          .data('siblings_before_edit', field.siblings())
          .attr('contenteditable', true)
          .blur(onBlur)
          .keypress(onKey)
          .keyup(onKey)

    $('body').on 'click', '[data-scrival-field-type="string"]:not([data-editor]), [data-editor="string"]', (event) ->
      event.preventDefault()

      unless cmsField?
        cmsField = $(event.currentTarget)
