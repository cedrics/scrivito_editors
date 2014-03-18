@Mediabrowser = do ->
  thumbnailViewButtonSelector: '.editing-button-view'
  options: {}

  # The media browser supports operations like +delete+ and +edit+ of resources that require a page
  # reload, so that all references of the resources get updated.
  reload: false

  _getBatchSize: ->
    @batchSize ||= 20

  _getThumbnailSize: ->
    @thumbnailSize ||= 'normal'

  _setThumbnailSize: (value) ->
    @thumbnailSize = value

  _filterListTemplate: (filters) ->
    list = $('<ul></ul>')
      .addClass('editing-mediabrowser-filter-items')

    for name, options of filters
      title = options.title
      icon = options.icon || 'editing-icon-generic'
      query = @_prepareQuery(options.query)

      @_filterTemplate(title, icon, query)
        .appendTo(list)

    list

  _loadFilter: () ->
    filters = @_selectedFilters()
    wrapper = @modal.find('.editing-mediabrowser-filter')

    @_filterListTemplate(filters)
      .appendTo(wrapper)

    @_defaultFilter().trigger('click')

  _selectedFilters: ->
    availableFilters = @filters()
    selectedFilters = @options.filters
    filters = availableFilters

    if selectedFilters?
      unless $.isArray(selectedFilters)
        selectedFilters = new Array(selectedFilters)

      filters = {}

      for filterId, filter of availableFilters
        if filterId in selectedFilters
          filters[filterId] = filter

    filters

  _defaultFilter: ->
    @_filterItems().first()

  _getFilterQuery: (filter) ->
    filter.data('query')

  _defaultQuery: ->
    @_getFilterQuery(@_defaultFilter())

  _activeQuery: ->
    filter = @_filterItems().filter('.active')
    @_getFilterQuery(filter)

  _filterItems: ->
    @modal.find('li.filter')

  _deactivateAllFilter: ->
    @_getSearch().val('')
    @_filterItems().removeClass('active')

  _triggerFilter: (filter) ->
    @_deactivateAllFilter()

    filter.addClass('active')

    query = @_getFilterQuery(filter)
    @_renderPlaceholder(query)

  _filterTemplate: (title, icon, query) ->
    filter = $('<li></li>')
      .addClass('filter')
      .data('query', query)

    icon = $('<span></span>')
      .addClass('editing-icon')
      .addClass(icon)
      .appendTo(filter)

    title = $('<span></span>')
      .addClass('editing-mediabrowser-filter-name')
      .html(title)
      .appendTo(filter)

    filter

  _prepareQuery: (query) ->
    params = $.extend(true, {}, query.query())
    scrival.chainable_search.create_instance(params)
      .order('_last_changed')
      .reverse_order()
      .format('mediabrowser')

  _save: ->
    (@options.onSave || $.noop)(@selected)

    @close()

  _delete: ->
    (@options.onDelete || $.noop)(@selected)

    $.each @selected, (index, id) =>
      item = @_getItemContainer(id)
      @_itemLoading(item)

      scrival.delete_obj(id).then =>
        @modal.trigger('resource_change.mediabrowser')
        item.remove()

    @_deselectAllItems()

  _getItemId: (item) ->
    $(item).closest('li.mediabrowser-item').data('id')

  _getItemContainer: (id) ->
    $('li.mediabrowser-item').filter ->
      id == $(this).data('id')

  _addItem: (item) ->
    @_activateItem(item)

    id = @_getItemId(item)

    @selected.push(id)
    @_setSelected($.unique(@selected))

  _removeItem: (item) ->
    @_deactivateItem(item)

    selected = @selected.filter (id) =>
      id != @_getItemId(item)

    @_setSelected(selected)

  _activateItem: (item) ->
    $(item).addClass('active')

  _deactivateItem: (item) ->
    $(item).removeClass('active')

  _changeSelectedTotal: ->
    @modal.find('.selected-total').html(@selected.length)

  _setSelected: (value) ->
    @selected = value || @options.selection || []
    @_changeSelectedTotal()

  _deselectAllItems: ->
    @_setSelected([])
    @modal.find('li.mediabrowser-item .select-item.active').removeClass('active')

  _getItems: ->
    @modal.find('.editing-mediabrowser-items')

  _getContainer: ->
    @modal.find('.editing-mediabrowser-thumbnails')

  _itemsPlaceholder: (count) ->
    size = @_getThumbnailSize()

    list = $('<ul></ul>')
      .addClass('items editing-mediabrowser-thumbnails')
      .addClass(size)

    content = for index in [0...count] by 1
      itemTemplate = @_itemPlaceholderTemplate(index)
      list.append(itemTemplate)

    @_getItems().html(content)

  _itemPlaceholderTemplate: (index) ->
    item = $('<li></li>')
      .addClass('mediabrowser-item')
      .attr('data-index', index)

    @_itemLoading(item)

  _itemLoading: (item) ->
    loading = @_loadingTemplate()
    $(item).html(loading)

  _renderPlaceholder: (query) ->
    query ||= @_defaultQuery()

    return unless query?

    @_getItems()
      .empty()
      .html(@_loadingTemplate())

    query.size()
      .then (total) =>
        if total > 0
          @_itemsPlaceholder(total)
          @_renderItems(query)
        else
          @_getItems().empty()

  _renderItems: (query, index = 0) ->
    query
      .batch_size(@_getBatchSize())

    query.load_batch()
      .then (result, next) =>
        objects = result.hits
        @_replacePlaceholder(objects, index)

        if next?
          start = index + objects.length
          @_renderItems(next, startIndex)

  _replacePlaceholder: (objects, startIndex) ->
    $(objects).each (index, object) =>
      elementIndex = startIndex + index
      template = @_itemTemplate(object)

      @modal.find("li.mediabrowser-item[data-index=#{elementIndex}]")
        .html(template)
        .data('id', object.id)

  _itemTemplate: (object) ->
    url = object.preview
    title = object.title || object.name
    id = object.id

    wrapper = $('<div></div>')

    preview = $('<div></div>')
      .addClass('editing-mediabrowser-preview')
      .appendTo(wrapper)

    image = if url?
      $('<img />')
        .attr('src', url)
    else
      $('<span></span>')
        .addClass('editing-icon')
        .addClass('editing-icon-generic')

    image.appendTo(preview)

    meta = $('<div></div>')
      .addClass('editing-mediabrowser-meta')
      .appendTo(wrapper)

    title = $('<span></span>')
      .addClass('editing-mediabrowser-thumbnails-name')
      .html(title)
      .appendTo(meta)

    select = $('<span></span>')
      .addClass('editing-mediabrowser-thumbnails-select select-item')
      .appendTo(title)

    if id in @selected
      select.addClass('active')

    wrapper

  _getSearch: ->
    @modal.find('input.search-field')

  _triggerSearch: ->
    term = @_getSearch().val()
    query = @_prepareQuery(@_activeQuery())

    if term? && term.length > 0
      query.and('*', 'contains_prefix', term)

    @_renderPlaceholder(query)

  _initializeBindings: ->
    $(window).resize ->
      $('#editing-mediabrowser.show').center()

    @modal.on 'keyup', 'input.search-field', (event) =>
      if event.keyCode == 13
        @_triggerSearch()

    @modal.on 'click', 'button.search-field-button', (event) =>
      event.preventDefault()
      @_triggerSearch()

    @modal.on 'click', 'li.mediabrowser-item .select-item:not(.active)', (event) =>
      event.stopImmediatePropagation()
      @_addItem(event.currentTarget)

    @modal.on 'click', 'li.mediabrowser-item .select-item.active', (event) =>
      event.stopImmediatePropagation()
      @_removeItem(event.currentTarget)

    @modal.on 'click', '.mediabrowser-save', (event) =>
      event.preventDefault()
      @_save()

    @modal.on 'click', '.mediabrowser-delete', (event) =>
      event.preventDefault()
      @_delete()

    @modal.on 'click', '.mediabrowser-close', (event) =>
      event.preventDefault()
      @close()

    @modal.on 'click', 'li.filter', (event) =>
      event.preventDefault()
      @_triggerFilter($(event.currentTarget))

    @modal.on 'click', @thumbnailViewButtonSelector, (event) =>
      size = $(event.currentTarget).data('size')
      @_changeThumbnailSize(size)

    @modal.on 'resource_change.mediabrowser', (event) =>
      @reload = true

    $(document).on 'keyup.mediabrowser', (event) =>
      event.stopImmediatePropagation()

      if event.keyCode == 27
        # Make sure to remove the event handler after
        # +stopImmediatePropagation()+, otherwise all ESC keys are caught and
        # not propagated.
        $(document).off 'keyup.mediabrowser'

        @close()

  _loadModal: (content) ->
    @overlay = $('<div></div>')
      .addClass('editing-overlay show')
      .appendTo($('body'))

    @modal = $('<div></div>')
      .addClass('editing-mediabrowser show')
      .attr('id', 'editing-mediabrowser')
      .appendTo($('body'))
      .center()
      .html(content)

    @_initializeBindings()

  _loadingTemplate: ->
    icon = $('<i></i>')
      .addClass('editing-icon editing-icon-refresh')

    $('<div></div>')
      .addClass('editing-mediabrowser-loading')
      .html(icon)

  _changeThumbnailSize: (size) ->
    size ||= @_getThumbnailSize()
    @_setThumbnailSize(size)

    transitionListener = 'webkitTransitionEnd.mediabrowser otransitionend.mediabrowser oTransitionEnd.mediabrowser msTransitionEnd.mediabrowser transitionend.mediabrowser'
    @modal.on transitionListener, 'li.mediabrowser-item', (event) =>
      @modal.off transitionListener

    @_getContainer()
      .removeClass('small normal big large')
      .addClass(size)

    @modal.find(@thumbnailViewButtonSelector)
      .removeClass('active')
      .filter("[data-size='#{size}']")
      .addClass('active')

  filters: ->
    {}

  close: ->
    (@options.onClose || $.noop)()

    @overlay.remove()
    @modal.remove()

    if @reload
      $('body').trigger('infopark_reload')

  open: (options) ->
    $.ajax
      url: '/mediabrowser/modal'
      dataType: 'json'
      success: (json) =>
        @options = options

        @_loadModal(json.content)
        @_setSelected()
        @_loadFilter()
        @_renderPlaceholder()
        @_changeThumbnailSize()

        MediabrowserInspector.init(@modal)
        MediabrowserUploader.init(@modal)

        MediabrowserUploader.onUploadFailure = (error) =>
          console.error('Mediabrowser Uploader Error:', error)

        MediabrowserUploader.onUploadSuccess = (objs) =>
          @_renderPlaceholder()
