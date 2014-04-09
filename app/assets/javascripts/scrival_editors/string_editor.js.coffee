$ ->
  # This file integrates a simple text input field to edit string attributes.

  timeout = undefined

  removeTags = (html) ->
    html.replace(/<\/?[^>]+>/gi, '')

  scrival.on 'editing', ->
    onKey = (event) ->
      if timeout
        clearTimeout(timeout)

      key = event.keyCode || event.which
      cmsField = $(event.currentTarget)

      switch key
        when 13 # Enter
          event.preventDefault()
          cmsField.blur()
        when 27 # Esc
          event.stopPropagation()
          cmsField
            .off('blur')
            .trigger('scrival_reload')
        else
          timeout = setTimeout ( ->
            save(cmsField)
          ), 3000

    onBlur = (event) ->
      cmsField = $(event.currentTarget)
      reload = cmsField.attr('data-reload') || 'false'

      save(cmsField).done ->
        if (reload == 'true')
          cmsField.trigger('scrival_reload')

    save = (cmsField) ->
      if timeout
        clearTimeout(timeout)

      content = removeTags(cmsField.html())
      cmsField.scrival('save', content)

    $('body').on 'click', '[data-scrival-field-type="string"]:not([data-editor]), [data-editor="string"]', (event) ->
      cmsField = $(event.currentTarget)

      unless cmsField.attr('contenteditable')?
        event.preventDefault()

        cmsField
          .attr('contenteditable', true)
          .keypress(onKey)
          .keyup(onKey)
          .blur(onBlur)
          .focus()
