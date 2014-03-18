$ ->
  # This file integrates a simple text input field to edit string attributes.

  timeout = undefined

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
      save(cmsField).done ->
        cmsField.trigger('scrival_reload')

    save = (cmsField) ->
      if timeout
        clearTimeout(timeout)

      content = cmsField.html()
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
