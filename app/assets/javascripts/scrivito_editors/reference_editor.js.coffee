$ ->
  # Integrates a resource browser based editor for reference CMS attributes.

  scrivito.on 'load', ->
    if scrivito.in_editable_view()
      $('body').on 'click', '[data-scrivito-field-type="reference"]:not([data-editor]), [data-editor~="reference"]', (event) ->
        event.preventDefault()

        cmsField = $(event.currentTarget)
        selected = [cmsField.scrivito('content')].filter (element) -> element
        filters = cmsField.data('filters') || cmsField.data('filter')

        # Open resource browser with current reference selected.
        Resourcebrowser.open
          selection: selected
          filters: filters
          selectionMode: 'single'

          onSave: (selection) =>
            onResourcebrowserSave(selection, cmsField)

      # Save single reference when resource browser calls "save".
      onResourcebrowserSave = (selection, cmsField) ->
        value = selection[0] || null

        cmsField.scrivito('save', value)
        .done ->
          cmsField.trigger('save.scrivito_editors')
          cmsField.trigger('scrivito_reload')

        true
