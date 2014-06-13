# v0.0.12
  * Rails no longer supports the `vendor` directory, so we moved the assets into the standard asset
    folder, so that they are integrated into the asset pipeline automatically.
  * Integrate new Scrivito SDK JavaScript events.
  * Editing `enum` and `multienum` fields no longer triggers a page or widget reload.

# v0.0.11
  * Added "Close" button to the HTML editor, to have an additional option to close the editor,
    besides hitting "Esc".
  * The new Scrivito SDK feature to serialize save requests allows editors to automatically save the
    content on every input instead of every 3 seconds. The `string`, `text` and `html` editor now
    all make use of this feature.
  * The "Esc" key on `string`, `text` and `html` editors now just destroys the editor, without
    resetting to any old content.
  * All editors now trigger a `save.scrivito_editors` event, when the content was successfully
    saved in the CMS.
  * `string` and `text` editors now only save, if the content has changed, as it is already
    the case for the `html` editor.
  * `referencelist` and `linklist` editors now make use of the new single selection mode option of
    the resource browser.

# v0.0.10
  * Extracted resource browser into separate gem.

# v0.0.9
  * Bugfix: It is now possible to have multiple string and text editors active at the same time.

# v0.0.8
  * Use Twitter Bootstrap styling for enum and multienum select fields.

# v0.0.7
  * Linklist and referencelist editors now better handle all aspects of the inplace editing process
    for these two attributes. The "add" button no longer has to be rendered by the application code.
    The styling of both editors was also improved to make it more user friendly.
  * Resourcebrowser: Thumbnails only display an image, if the object defines a `image?` method, that
    returns `true`, otherwise a generic icon is rendered.
  * Bugfix: The string and text editor now also save correctly, when highlighting and editing the
    content without triggering a `click` event.
  * Bugfix: The placeholder now also works for attributes, that have been cleared without triggering
    a reload of the page afterwards. (Thanks @gertimon)
  * Bugfix: The default placeholder text for empty CMS attributes only used the name of the first
    attribute on the page, instead of the correct field name for each CMS attribute.

# v0.0.6
  * Rewrite of string and text editor to better support pasting HTML, correctly handling quotes,
    inserting the carrot at the correct position and better multiline support for preformatted text
    fields. (Thanks @dcsaszar)
  * Bugfix: Using renamed `obj_class_name` method from the new Scrivito SDK instead of `obj_class`.
  * Changed the behavior when an item is clicked in the resource browser. Instead of opening the
    inspector, the item is now selected or deselected. A small magnifying glass in the upper right
    corner of the thumbnail now allows to open the inspector for the item.
  * Rename the fallback inspector view to `details.html`, to be consistent to the new Scrivito SDK.

# v0.0.5
  * The template used in the inspector is no longer configurable and always corresponds to the
    details view used by the Scrivito SDK.
  * Bugfix: The resource browser did not use a correct start index to render multiple thumbnails.

# v0.0.4
  * Bugfix: Resourcebrowser buttons now also work in Chrome browser.

# v0.0.3
  * Updated redactor to version 9.2.1 and removed all custom settings.
  * Added option `data-reload` to the string editor to configure if a reload event should
    be triggered or not after saving the changes. (Thanks @apepper)

# v0.0.2
  * Added placeholder text to empty CMS attributes.

# v0.0.1
  * Updated html editor seperator height from 29px to 27px.
  * Updated the README to describe the new gem.
  * Added editing icons used in some of the editors and the resource browser.
  * Removed the saving animation for editors to not disturb the in-place editing
    experience.
