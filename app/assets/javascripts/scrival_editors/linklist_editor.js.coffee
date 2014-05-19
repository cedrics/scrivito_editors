$ ->
  # An editor for CMS linklist attributes.

  # Creates the DOM for one link element of the linklist and substitutes the
  # title and url attribute.
  template = (attributes) ->
    attributes ||= {}

    title = attributes['title'] || ''
    url = attributes['url'] || ''

    $("<input type=\"text\" name=\"title\" value=\"#{title}\" placeholder=\"Title\" />
       <input type=\"text\" name=\"url\" value=\"#{url}\" placeholder=\"Url\" class=\"editing-url\" />
       <div class=\"actions\">
         <a href=\"#\" class=\"editing-button mediabrowser-open editing-green\">
           <i class=\"editing-icon editing-icon-search\" />
         </a>
         <a href=\"#\" class=\"editing-button editing-red delete\">
           <i class=\"editing-icon editing-icon-trash\" />
         </a>
       </div>")

  mediabrowserButtonTemplate = ->
    icon = $('<i></i>')
      .addClass('editing-icon')
      .addClass('editing-icon-plus')

    button = $('<button></button>')
      .addClass('editing-button')
      .addClass('editing-green')
      .addClass('add-link')
      .html(icon)

    button

  # Returns the closest linklist DOM element.
  getCmsField = (element) ->
    element.closest('[data-scrival-field-type=linklist]')

  # Saves the entire linklist to the CMS and stores the last successfully saved value.
  save = (cmsField) ->
    value = getAttributes(cmsField)
    lastSaved = getLastSaved(cmsField)

    unless JSON.stringify(value) == JSON.stringify(lastSaved)
      cmsField.scrival('save', value).done ->
        storeLastSaved(cmsField, value)

  # Run when clicking the '...' button inside a li.
  onOpenMediabrowser = (event) ->
    event.preventDefault()

    linkItem = $(event.currentTarget).closest('li')
    cmsField = getCmsField(linkItem)
    filters = cmsField.data('filters') || cmsField.data('filter')

    Mediabrowser.open
      selection: []
      filters: filters
      onSave: (selection) =>
        onMediabrowserSaveLinkItem(selection, linkItem)

  # Media browser callback for saving a single link.
  onMediabrowserSaveLinkItem = (selection, linkItem) ->
    url = buildUrl(selection[0])
    linkItem.find('[name=url]').val(url)

    # trigger save after inserting the value
    cmsField = getCmsField(linkItem)
    save(cmsField)

    true

  # Transforms an obj id into an url that can be parsed by Scrival
  # to establish an internal link.
  buildUrl = (id) ->
    "/#{id}"

  # Collects all link attributes for a given linklist.
  getAttributes = (cmsField) ->
    items = $(cmsField).find('li')

    attributes =
      for item in items
        item = $(item)
        title = item.find('[name=title]').val()
        url = item.find('[name=url]').val()

        # Make sure the url is not empty.
        if !isEmpty(url)
          'title': title
          'url': url

    # Remove empty array elements.
    removeEmptyElements(attributes)

  isEmpty = (value) ->
    !value

  removeEmptyElements = (array) ->
    $.grep(array, (n) -> n)

  # Adds a new link to the linklist.
  addLink = (event) ->
    event.preventDefault()

    cmsField = getCmsField($(event.currentTarget))
    content = $('<li>').html(template())

    cmsField.find('ul').append(content)

  # Removes a link from the linklist.
  removeLink = (event) ->
    event.preventDefault()

    target = $(event.currentTarget)
    cmsField = getCmsField(target)

    target.closest('li').remove()
    save(cmsField)

  # Turns the server side generated linklist data into the linklist editor using a template.
  transformLinks = (cmsFields) ->
    cmsFields.append(mediabrowserButtonTemplate)

    items = cmsFields.find('li')

    for item in items
      item = $(item)

      content = template
        title: item.data('title')
        url: item.data('url')

      item.html(content)

  # Returns the last saved value.
  getLastSaved = (cmsField) ->
    cmsField.data('last-saved')

  # Stores a given value as last saved.
  storeLastSaved = (cmsField, value) ->
    $(cmsField).data('last-saved', value)

  # Automatically save when focus is lost.
  onBlur = (event) ->
    cmsField = getCmsField($(event.currentTarget))

    save(cmsField)

  initialize = (root) ->
    linklistElements = $(root).find('[data-scrival-field-type="linklist"]:not([data-editor]), [data-editor="linklist"]')

    if linklistElements.length
      transformLinks(linklistElements)

      for linklistElement in linklistElements
        storeLastSaved(linklistElement, getAttributes(linklistElement))

      linklistElements.on 'blur', 'li input', onBlur
      linklistElements.on 'click', 'li a.delete', removeLink
      linklistElements.on 'click', 'button.add-link', addLink
      linklistElements.on 'click', 'a.mediabrowser-open', onOpenMediabrowser

      linklistElements.find('ul').sortable
        update: (event) ->
          cmsField = getCmsField($(event.target))

          save(cmsField)

  # Initialize linklist editor and setup event callbacks.
  scrival.on 'new_content', (root) ->
    initialize(root)

  scrival.on 'editing', ->
    initialize(document)
