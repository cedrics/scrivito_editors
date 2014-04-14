$ ->
  # This file integrates contenteditable for text attributes.
  # It provides multiline editing support.

  timeout = undefined

  scrival.on 'editing', ->
    cmsField = undefined

    onKey = (event) ->
      if timeout
        clearTimeout(timeout)

      key = event.keyCode || event.which

      switch key
        when 27 # Esc
          event.stopPropagation()
          cmsField
            .off('blur')
            .trigger('scrival_reload')
        else
          timeout = setTimeout ( ->
            save()
          ), 3000

    onBlur = (event) ->
      cmsField.find('br').replaceWith('\n')
      reload = cmsField.attr('data-reload') || 'false'

      save().done ->
        if (reload == 'true')
          cmsField.trigger('scrival_reload')

    save = () ->
      if timeout
        clearTimeout(timeout)

      clone = cmsField.siblings().addBack().not(cmsField.data('siblings_before_edit')).clone()
      clone.find('br').replaceWith('\n')
      content = clone.text()
      clone.remove()
      cmsField.scrival('save', content)

    $('body').on 'mouseenter', '[data-scrival-field-type="text"]:not([data-editor]), [data-editor="text"]', (event) ->
      field = $(event.currentTarget)

      html = field.html()
      html_nl2br = html.replace(/\n/g, '<br />')
      field.html(html_nl2br) if html != html_nl2br

      unless field.attr('contenteditable')?
        field
          .data('siblings_before_edit', field.siblings())
          .attr('contenteditable', true)
          .keypress(onKey)
          .keyup(onKey)
          .blur(onBlur)
        cmsField = field