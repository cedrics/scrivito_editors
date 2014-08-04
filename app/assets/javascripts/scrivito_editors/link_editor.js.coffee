$ ->
  # An editor for CMS linklist attributes.

  # Creates the DOM for one link element of the linklist and substitutes the
  # title and url attribute.
  template = (attributes) ->
    attributes ||= {}

    title = attributes['title'] || ''
    url = attributes['url'] || ''

    $("<ul><li>
       <input type=\"text\" name=\"title\" value=\"#{title}\" placeholder=\"Title\" />
       <input type=\"text\" name=\"url\" value=\"#{url}\" placeholder=\"Url\" class=\"editing-url\" />
       <div class=\"actions\">
         <a href=\"#\" class=\"editing-button resourcebrowser-open editing-green\">
           <i class=\"editing-icon editing-icon-search\" />
         </a>
       </div></li></ul>")

  resourcebrowserButtonTemplate = ->
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
    element.closest('[data-scrivito-field-type=link]')

  # Saves the entire linklist to the CMS and stores the last successfully saved value.
  save = (cmsField) ->
    value = getAttributes(cmsField) || null

    cmsField.scrivito('save', value).done ->
      cmsField.trigger('save.scrivito_editors')

  # Run when clicking the '...' button inside a li.
  onOpenResourcebrowser = (event) ->
    event.preventDefault()

    linkItem = $(event.currentTarget).closest('li')
    cmsField = getCmsField(linkItem)
    filters = cmsField.data('filters') || cmsField.data('filter')

    Resourcebrowser.open
      selection: []
      filters: filters
      selectionMode: 'single'
      onSave: (selection) =>
        onResourcebrowserSaveLinkItem(selection, linkItem)

  # Resource browser callback for saving a single link.
  onResourcebrowserSaveLinkItem = (selection, linkItem) ->
    url = buildUrl(selection[0])
    linkItem.find('[name=url]').val(url)

    # trigger save after inserting the value
    cmsField = getCmsField(linkItem)
    save(cmsField)

    true

  # Transforms an obj id into an url that can be parsed by Scrivito
  # to establish an internal link.
  buildUrl = (id) ->
    "/#{id}"

  # Collects all link attributes.
  getAttributes = (cmsField) ->
    items = $(cmsField).find('li')

    if items.length > 0
      item = $(items[0])
      title = item.find('[name=title]').val()
      url = item.find('[name=url]').val()

      if url
        'title': title
        'url': url

  # Turns the server side generated link data into the link editor using a template.
  transformLinks = (cmsFields) ->
    for cmsField in cmsFields
      cmsField = $(cmsField)
      items = cmsField.find('li')

      for item in items
        item = $(item)

        content = template
          title: item.data('title')
          url: item.data('url')

        item.html(content)

      if items.length == 0
        cmsField.append(template())

  # Automatically save when focus is lost.
  onBlur = (event) ->
    cmsField = getCmsField($(event.currentTarget))

    save(cmsField)

  initialize = (root) ->
    linkElements = $(root).find('[data-scrivito-field-type="link"]:not([data-editor]), [data-editor="link"]')

    if linkElements.length
      transformLinks(linkElements)

      linkElements.on 'blur', 'li input', onBlur
      linkElements.on 'click', 'a.resourcebrowser-open', onOpenResourcebrowser

  # Initialize link editor and setup event callbacks.
  scrivito.on 'content', (root) ->
    initialize(root)
