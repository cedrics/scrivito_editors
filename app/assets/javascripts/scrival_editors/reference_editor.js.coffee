$ ->
  # Integrates a mediabrowser based editor for reference CMS attributes.

  scrival.on 'editing', ->
    $('body').on 'click', '[data-scrival-field-type="reference"]:not([data-editor]), [data-editor="reference"]', (event) ->
      event.preventDefault()

      cmsField = $(event.currentTarget)
      selected = [cmsField.scrival('content')].filter (element) -> element
      filters = cmsField.data('filters') || cmsField.data('filter')

      # Open mediabrowser with current reference selected and restrict selection to one reference.
      Mediabrowser.open
        selection: selected
        filters: filters

        onSave: (selection) =>
          onMediabrowserSave(selection, cmsField)

    # Save single reference when media browser calls "save".
    onMediabrowserSave = (selection, cmsField) ->
      cmsField.addClass('saving')

      value = selection[0] || null

      cmsField.scrival('save', value)
      .done ->
        cmsField.trigger('scrival_reload')
      .fail ->
        cmsField.removeClass('saving')

      true
