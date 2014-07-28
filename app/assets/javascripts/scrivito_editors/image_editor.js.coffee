$ ->
  # Integrates an image drag & drop editor.

  scrivito.on 'load', ->
    if scrivito.in_editable_view()
      # Activate the image editor for all supported field types.
      activateForFieldType('linklist')
      activateForFieldType('reference')

      # Activate the image editor if it is explicitely selected.
      activateForSelector('[data-editor~="image"]')

      # Disable DnD for all elements by default to prevent the user
      # from accidentally opening an image in browser.
      $('body').on 'dragover', -> false
      $('body').on 'drop', -> false

  statusIndicatorClass = 'image-editor-dragover'

  activateForFieldType = (fieldType) ->
    selector = 'img[data-scrivito-field-type=' + fieldType  + ']:not([data-editor])'
    activateForSelector(selector)

  activateForSelector = (selector) ->
    bodyElement = $('body')
    bodyElement.on 'dragover.image-editor', selector, (event) ->
      event.preventDefault()
      $(event.target).addClass(statusIndicatorClass)

    bodyElement.on 'dragleave.image-editor', selector, (event) ->
      event.preventDefault()
      $(event.target).removeClass(statusIndicatorClass)

    bodyElement.on 'drop.image-editor', selector, (event) ->
      event.preventDefault()
      target = $(event.target)
      fieldType = target.attr('data-scrivito-field-type')
      save(event, $(event.target), fieldType)

  save = (event, element, fieldType) ->
    file = fetchFile(event, element)
    return unless file

    createImage(file).then (obj) ->
      value = switch
        when fieldType == 'reference' then obj.id
        when fieldType == 'linklist' then [{obj_id: obj.id}]
        else $.error('Field type must be "reference" or "linklist".')

      element.scrivito('save', value).then ->
        element.trigger('scrivito_reload')

  fetchFile = (event, element) ->
    data_transfer = event.originalEvent.dataTransfer
    return unless data_transfer

    files = data_transfer.files
    if (files.length > 1)
      alert('You dropped multiple files, but only one file is supported.')
      element.removeClass(statusIndicatorClass)
      return

    files[0]

  createImage = (file) ->
    name = file.name.replace(/[^a-z0-9_.$\-]/ig, '-')
    path = '_resources/' + Math.floor(Math.random() * 1000) + '/' + name

    scrivito.create_obj
      blob: file
      _path: path
      _obj_class: 'Image'
