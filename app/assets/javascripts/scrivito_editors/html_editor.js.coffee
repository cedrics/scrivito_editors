# Configuration and behavior of Redactor html editor. The editor is used for all html CMS
# attributes and provides autosave on top of the default Redactor settings.

# Check if the namespace for plugins exists and create it otherwise.
unless @RedactorPlugins?
  @RedactorPlugins = {}

# Plugin for closing the editor with a button in the toolbar.
@RedactorPlugins.close =
  init: ->
    @buttonAddFirst('close', 'Close', @closeAction)

  closeAction: (buttonName, buttonDOM, buttonObj, event) ->
    @.callback('blur')

$ ->
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
      plugins: ['close']

      # This option allows you to set whether Redactor gets cursor focus on load or not.
      # http://imperavi.com/redactor/docs/settings/#set-focus
      focus: true

      # With this option turned on, Redactor will automatically replace divs to paragraphs.
      # http://imperavi.com/redactor/docs/settings/#set-convertDivs
      convertDivs: false

      # This callback fires every time when content changes in Redactor.
      # http://imperavi.com/redactor/docs/callbacks/#callback-changeCallback
      changeCallback: ->
        saveContents(@)

      # This callback is triggered when Redactor loses focus.
      # http://imperavi.com/redactor/docs/callbacks/#callback-blurCallback
      blurCallback: ->
        @.destroy()
        saveContents(@)

      # This callback is triggered when a key is released.
      # http://imperavi.com/redactor/docs/callbacks/#callback-keyupCallback
      keyupCallback: (event) ->
        event.stopPropagation()
        key = event.keyCode || event.which

        if key == 27
          @.callback('blur')
        else
          saveContents(@)

      # This callback allows to get pasted code after clean on paste.
      # http://imperavi.com/redactor/docs/callbacks/#callback-pasteAfterCallback
      pasteAfterCallback: (html) ->
        saveContents(@)
        html

  # Saves the current editor content to the CMS.
  saveContents = (editor) ->
    cmsField = editor.$element
    content = editor.get()

    if content != cmsField.scrivito('content')
      cmsField.scrivito('save', content).done ->
        cmsField.trigger('save.scrivito_editors')
    else
      $.Deferred().resolve()

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
