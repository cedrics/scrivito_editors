$ ->
  # An editor for CMS referencelist attributes.

  # Creates the DOM for one reference element of the referencelist and substitutes the
  # name and id attribute.
  itemTemplate = ->
    $("<div class=\"actions\">
         <a href=\"#\" class=\"editing-button editing-red delete\">
           <i class=\"editing-icon editing-icon-trash\" />
         </a>
       </div>")

  resourcebrowserButtonTemplate = ->
    icon = $('<i></i>')
      .addClass('editing-icon')
      .addClass('editing-icon-plus')

    button = $('<button></button>')
      .addClass('editing-button')
      .addClass('editing-green')
      .addClass('resourcebrowser-open')
      .html(icon)

    button

  # Returns the closest referencelist DOM element.
  getCmsField = (element) ->
    element.closest('[data-scrivito-field-type=referencelist]')

  # Saves the referencelist to the CMS when changed and stores the last successfully saved value.
  save = (ids, cmsField) ->
    lastSaved = getLastSaved(cmsField)

    unless JSON.stringify(ids) == JSON.stringify(lastSaved)
      cmsField.scrivito('save', ids)
        .done ->
          storeLastSaved(cmsField, ids)
          cmsField.trigger('save.scrivito_editors')
          cmsField.trigger('scrivito_reload')

  # Run when clicking the resource browser button.
  onResourcebrowserOpen = (event) ->
    event.preventDefault()

    cmsField = getCmsField($(event.currentTarget))
    filters = cmsField.data('filters') || cmsField.data('filter')
    ids = getIds(cmsField)

    Resourcebrowser.open
      selection: ids
      filters: filters

      onSave: (selection) =>
        save(selection, cmsField)

  # Collects all reference ids for a given referencelist.
  getIds = (cmsField) ->
    items = $(cmsField).find('li')

    value =
      for item in items
        $(item).data('id')

  # Removes a single reference from the referencelist.
  remove = (event) ->
    event.preventDefault()

    target = $(event.currentTarget)
    cmsField = getCmsField(target)

    target.closest('li').remove()

    ids = getIds(cmsField)
    save(ids, cmsField)

  # Turns the server side generated referencelist data into the reference editor using a template.
  transform = (elements) ->
    elements.append(resourcebrowserButtonTemplate)

    items = elements.find('li')

    for item in items
      $(item).append(itemTemplate)

  # Returns the last saved value.
  getLastSaved = (cmsField) ->
    $(cmsField).data('last-saved')

  # Stores a given value as last saved.
  storeLastSaved = (cmsField, value) ->
    $(cmsField).data('last-saved', value)

  # Initialize referencelist editor and setup event callbacks.
  scrivito.on 'content', (root) ->
    if scrivito.in_editable_view()
      elements = $(root).find('[data-scrivito-field-type="referencelist"]:not([data-editor]), [data-editor~="referencelist"]')

      if elements.length
        transform(elements)

        for element in elements
          ids = getIds(element)
          storeLastSaved(element, ids)

        elements.on 'click', 'li a.delete', remove
        elements.on 'click', 'button.resourcebrowser-open', onResourcebrowserOpen

        elements.find('ul').sortable
          update: (event) ->
            cmsField = getCmsField($(event.target))
            ids = getIds(cmsField)

            save(ids, cmsField)
