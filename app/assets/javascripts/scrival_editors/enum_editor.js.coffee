$ ->
  # Define editor behavior for enum attributes.

  scrival.on 'editing', ->
    template = (values) ->
      element = $('<select></select>')

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
      cmsField.scrival('save', content).done ->
        cmsField.trigger('scrival_reload')

    $(document).on 'click', '[data-scrival-field-type="enum"]:not([data-editor]), [data-editor="enum"]', (event) ->
      cmsField = $(event.currentTarget)
      selected = cmsField.scrival('content')
      values = cmsField.data('values')

      template(values)
        .data('cmsField', cmsField)
        .val(selected)
        .insertAfter(cmsField)
        .focusout(save)
        .focus()

      cmsField.hide()
