$ ->
  # Slider for integer values stored in a string CMS attribute.

  scrivito.on 'load', ->
    if scrivito.in_editable_view()
      template = ->
        $('<div></div>')

      onStop = (event, ui) ->
        cmsField = $(@).data('cmsField')
        content = ui.value
        cmsField.scrivito('save', content).done ->
          cmsField.trigger('save.scrivito_editors')
          cmsField.trigger('scrivito_reload')

      onSlide = (event, ui) ->
        cmsField = $(@).data('cmsField')
        content = ui.value
        cmsField.text(ui.value)

      $('body').on 'click', '[data-editor~="slider"]:not(.active)', (event) ->
        cmsField = $(event.currentTarget)
        content = cmsField.scrivito('content')
        min = cmsField.attr('data-min') || 1
        max = cmsField.attr('data-max') || 10
        step = cmsField.attr('data-step') || 1

        cmsField.addClass('active')

        template()
          .data('cmsField', cmsField)
          .insertAfter(cmsField)
          .slider(
            min: parseInt(min)
            max: parseInt(max)
            step: parseInt(step)
            value: content
            range: 'min'
            stop: onStop
            slide: onSlide
          )
