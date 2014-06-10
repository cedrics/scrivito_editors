$ ->
  # Define editor behavior for multienum attributes.

  scrivito.on 'load', ->
    if scrivito.in_editable_view()
      template = (values) ->
        element = $('<select></select>')
          .attr('multiple', 'true')
          .addClass('form-control')

        $.each values, (index, value) ->
          $('<option></option>')
            .attr('value', value)
            .text(value)
            .appendTo(element)

        element

      save = (event) ->
        element = $(event.currentTarget)
        cmsField = element.data('cmsField')
        content = element.val()
        cmsField.scrivito('save', content).done ->
          cmsField.trigger('save.scrivito_editors')

      $(document).on 'click', '[data-scrivito-field-type="multienum"]:not([data-editor]), [data-editor="multienum"]', (event) ->
        cmsField = $(event.currentTarget)
        selected = cmsField.scrivito('content')
        values = cmsField.data('values')

        template(values)
          .data('cmsField', cmsField)
          .val(selected)
          .insertAfter(cmsField)
          .focusout(save)
          .focus()

        cmsField.hide()
