# Configuration and behavior of Redactor html editor. The editor is used for all html CMS
# attributes and provides autosave on top of the default Redactor settings.

# Check if the namespace for plugins exists and create it otherwise.
unless @RedactorPlugins?
  @RedactorPlugins = {}

# Plugin for saving and closing the editor with a button in the toolbar.
@RedactorPlugins.save =
  init: ->
    @buttonAddFirst('save', 'Save and close', @saveAction)

  saveAction: (buttonName, buttonDOM, buttonObj, event) ->
    @.callback('blur', event)

# Plugin for closing the editor without saving with a button in the toolbar.
@RedactorPlugins.close =
  init: ->
    @buttonAddAfter('save', 'close', 'Close without saving', @closeAction)

  closeAction: (buttonName, buttonDOM, buttonObj, event) ->
    event.keyCode = 27
    @.callback('keyup', event)

$ ->
  # Stores the id of the last triggered timeout for later reference.
  timeoutID = undefined

  # Milliseconds after which to save the content automatically.
  autosaveInterval = 3000

  # Stores the last saved content written to the CMS to allow comparison with editor content.
  savedContent = undefined

  # Stores the content before the editor is opened and changes occur.
  originalContent = undefined

  # Stores redactor options, custom settings and configures callbacks.
  redactorOptions = ->
    return {} =
      # This setting defines the array of toolbar buttons.
      # http://imperavi.com/redactor/docs/settings/#set-buttons
      buttons: [
        'formatting', 'bold', 'italic', 'deleted', 'underline',
        'unorderedlist', 'orderedlist', 'table', 'link', 'html',
      ]

      # This options allows to configure what plugins are loaded. Plugins need to be defined in the
      # +RedactorPlugins+ namespace.
      plugins: ['save', 'close']

      # This option allows you to set whether Redactor gets cursor focus on load or not.
      # http://imperavi.com/redactor/docs/settings/#set-focus
      focus: true

      # With this option turned on, Redactor will automatically replace divs to paragraphs.
      # http://imperavi.com/redactor/docs/settings/#set-convertDivs
      convertDivs: false

      # This callback is triggered after Redactor is launched.
      # http://imperavi.com/redactor/docs/callbacks/#callback-initCallback
      initCallback: ->
        originalContent = @get()

      # This callback fires every time when content changes in Redactor.
      # http://imperavi.com/redactor/docs/callbacks/#callback-changeCallback
      changeCallback: ->
        autosaveAction(@)

      # This callback is triggered when Redactor loses focus.
      # http://imperavi.com/redactor/docs/callbacks/#callback-blurCallback
      blurCallback: ->
        saveContents(@).done =>
          @.destroy()
          reload(@)

      # This callback is triggered when a key is released.
      # http://imperavi.com/redactor/docs/callbacks/#callback-keyupCallback
      keyupCallback: (event) ->
        event.stopPropagation()
        key = event.keyCode || event.which

        if key == 27
          cancelEditing(@)
        else
          autosaveAction(@)

      # This callback allows to get pasted code after clean on paste.
      # http://imperavi.com/redactor/docs/callbacks/#callback-pasteAfterCallback
      pasteAfterCallback: (html) ->
        autosaveAction(@)
        html

  # Registers a timeout to save the editor content after a certain interval. The timeout gets reset
  # on every change.
  autosaveAction = (editor) ->
    if timeoutID
      clearTimeout(timeoutID)

    timeoutID = setTimeout ( ->
      saveContents(editor)
    ), autosaveInterval

  # Saves the current editor content to the CMS if it has changed.
  saveContents = (editor) ->
    content = editor.get()

    if savedContent != content
      cmsField = editor.$element
      cmsField.scrivito('save', content).done ->
        savedContent = content
        cmsField.trigger('save.scrivito_editors')
    else
      $.Deferred().resolve()

  reload = (editor) ->
    cmsField = editor.$element
    cmsField.trigger('scrivito_reload')

  # Restores the original content before the editor was opened, also saves it back to the CMS
  # because autosave could have overwritten the content and closes the editor.
  cancelEditing = (editor) ->
    editor.set(originalContent)
    saveContents(editor).done ->
      reload(editor)
    editor.destroy()

  # Registers Redactor for all CMS html attributes found in the given scope of the DOM element.
  addOnclickRedactorHandlers = (domElement) ->
    domElement.on 'click', '[data-scrivito-field-type="html"]:not([data-editor]), [data-editor="html"]', (event) ->
      event.preventDefault()
      cmsField = $(@)

      unless cmsField.hasClass('redactor_editor')
        cmsField.html(cmsField.scrivito('content') || '')
        cmsField.redactor(redactorOptions())
        cmsField.redactor('focus')

  # Registers all handlers when inplace editing is activated.
  scrivito.on 'editing', ->
    addOnclickRedactorHandlers($('body'))

  # Registers all handlers when content has changed.
  scrivito.on 'new_content', (domElement) ->
    addOnclickRedactorHandlers($(domElement))
