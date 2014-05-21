# v0.0.8
  * Use Twitter Bootstrap styling for enum and multienum select fields.
  
# v0.0.7
  * Linklist and referencelist editors now better handle all aspects of the inplace editing process
    for these two attributes. The "add" button no longer has to be rendered by the application code.
    The styling of both editors was also improved to make it more user friendly.
  * Mediabrowser: Thumbnails only display an image, if the object defines a `image?` method, that
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
  * Changed the behavior when an item is clicked in the mediabrowser. Instead of opening the
    inspector, the item is now selected or deselected. A small magnifying glass in the upper right
    corner of the thumbnail now allows to open the inspector for the item.
  * Rename the fallback inspector view to `details.html`, to be consistent to the new Scrivito SDK.

# v0.0.5
  * The template used in the inspector is no longer configurable and always corresponds to the
    details view used by the Scrivito SDK.
  * Bugfix: The mediabrowser did not use a correct start index to render multiple thumbnails.

# v0.0.4
  * Bugfix: Mediabrowser buttons now also work in Chrome browser.

# v0.0.3
  * Updated redactor to version 9.2.1 and removed all custom settings.
  * Added option `data-reload` to the string editor to configure if a reload event should
    be triggered or not after saving the changes. (Thanks @apepper)

# v0.0.2
  * Added placeholder text to empty CMS attributes.

# v0.0.1
  * Updated html editor seperator height from 29px to 27px.
  * Updated the README to describe the new gem.
  * Added editing icons used in some of the editors and the media browser.
  * Removed the saving animation for editors to not disturb the in-place editing
    experience.
