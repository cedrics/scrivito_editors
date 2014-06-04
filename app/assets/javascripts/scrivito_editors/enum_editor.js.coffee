$ ->
  # Define editor behavior for enum attributes.

  scrivito.on 'editing', ->
    template = (values) ->
      element = $('<select></select>')
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

    $(document).on 'click', '[data-scrivito-field-type="enum"]:not([data-editor]), [data-editor="enum"]', (event) ->
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
