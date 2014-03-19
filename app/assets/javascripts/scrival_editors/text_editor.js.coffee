$ ->
  # This file integrates a simple text input field to edit string attributes.

  timeout = undefined

  scrival.on 'editing', ->
    template = ->
      editor = $('<div></div>')
        .addClass('text-editor')

      input = $('<textarea />')
        .attr('rows', '6')
        .appendTo(editor)

      editor

    getBox = (element) ->
      element.closest('.text-editor')

    editMarker = (cmsField) ->
      cmsField.closest('[data-scrival-private-widget-obj-class]').find('.scrival_editing_marker')

    disableEditMode = (box) ->
      cmsField = box.data('cmsField')

      cmsField.show()
      editMarker(cmsField).show()
      box.remove()

    keyUp = (event) ->
      event.stopPropagation()
      key = event.keyCode || event.which

      if timeout
        clearTimeout(timeout)

      switch key
        when 27 # Esc
          cancel(event)
        else
          timeout = setTimeout ( ->
            save(event)
          ), 3000

    save = (event, closeInput = false) ->
      inputField = $(event.currentTarget)
      content = inputField.val()
      box = getBox(inputField)
      cmsField = box.data('cmsField')

      if timeout
        clearTimeout(timeout)

      cmsField.scrival('save', content).done ->
        if closeInput
          cmsField.html(content)
          disableEditMode(box)

    cancel = (event) ->
      box = getBox($(event.currentTarget))

      disableEditMode(box)

    onBlur = (event) ->
      save(event, true)

    $('body').on 'click', '[data-scrival-field-type="text"]:not([data-editor]), [data-editor="text"]', (event) ->
      event.preventDefault()
      event.stopPropagation()

      cmsField = $(this)

      template()
        .data('cmsField', cmsField)
        .insertAfter(cmsField)
        .find('textarea')
        .val(cmsField.scrival('content') || '')
        .focusout(onBlur)
        .keyup(keyUp)
        .focus()

      cmsField.hide()
      editMarker(cmsField).hide()
