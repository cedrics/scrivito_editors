$ ->
  # This file integrates contenteditable for text attributes.
  # It provides multiline editing support.

  scrival.on 'editing', ->
    cmsField = undefined
    timeout = undefined

    onKey = (event) ->
      if timeout?
        clearTimeout(timeout)

      if cmsField?
        key = event.keyCode || event.which

        switch key
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

      clone = cmsFieldAndPastedContent().clone()
      clone.find('br').replaceWith('\n')
      content = clone.text()
      clone.remove()

      field = cmsField

      if andClose
        cmsField.text(content)
        cmsField = undefined

      field.scrival('save', content)

    cleanUp = ->
      siblings = cmsFieldAndPastedContent()
      pasted = siblings.not(cmsField)
      if pasted.length > 0
        pasted.remove()
        cmsField.text(siblings.text())

    cmsFieldAndPastedContent = ->
      cmsField.siblings().addBack().not(cmsField.data('siblings_before_edit'))

    $('body').on 'mouseenter', '[data-scrival-field-type="text"]:not([data-editor]), [data-editor="text"]', (event) ->
      unless cmsField?
        cmsField = $(event.currentTarget)

      html = cmsField.html()
      html_nl2br = html.replace(/\n/g, '<br />')
      cmsField.html(html_nl2br) if html != html_nl2br

      unless cmsField.attr('contenteditable')?
        cmsField
          .data('siblings_before_edit', cmsField.siblings())
          .attr('contenteditable', true)
          .blur(onBlur)
          .keypress(onKey)
          .keyup(onKey)
