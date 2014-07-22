$ ->
  # Define editor behavior for date attributes.

  scrivito.on 'load', ->
    if scrivito.in_editable_view()
      template = ->
        $('<input />')
          .attr('type', 'text')

      onKeyup = (event) ->
        key = event.keyCode || event.which

        switch key
          when 27 # Esc
            # Prevent the property view to close when the ESC key is pressed.
            event.stopPropagation()

      save = (dateTimeText) ->
        element = $(this)
        cmsField = element.data('cmsField')

        if dateTimeText? && dateTimeText.length > 0
          dateTimeText = new Date(dateTimeText)

        cmsField.scrivito('save', dateTimeText)
          .done ->
            cmsField.trigger('save.scrivito_editors')
            cmsField.trigger('scrivito_reload')

      $('body').on 'click', '[data-scrivito-field-type="date"]:not(.hasDatepicker):not([data-editor]), [data-editor~="date"]', (event) ->
        event.preventDefault()

        cmsField = $(this)
        content = cmsField.html().trim()
        dateFormat = cmsField.attr('data-date-format') || 'yy-mm-dd'
        timeFormat = cmsField.attr('data-time-format') || 'HH:mm:ss'

        $('body').keyup(onKeyup)

        template()
          .data('cmsField', cmsField)
          .insertAfter(cmsField)
          .val(content)
          .keyup(onKeyup)
          .datetimepicker(
            dateFormat: dateFormat
            timeFormat: timeFormat
            onClose: save
          )
          .focus()

        cmsField.hide()
