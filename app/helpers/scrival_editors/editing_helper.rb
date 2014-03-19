module ScrivalEditors
  module EditingHelper
    def cms_edit_enum(object, attribute_name, options = {})
      attribute_definition = object.cms_attribute_definition(attribute_name)
      values = attribute_definition['values']

      options.reverse_merge!({
        data: {
          values: values,
          min: values.min,
          max: values.max,
        }
      })

      cms_tag(:div, object, attribute_name, options)
    end

    def cms_edit_multienum(object, attribute_name, options = {})
      attribute_definition = object.cms_attribute_definition(attribute_name)

      options.reverse_merge!({
        multiple: true,
        data: {
          values: attribute_definition['values'],
        }
      })

      cms_tag(:div, object, attribute_name, options) do |tag|
        (object[attribute_name] || []).join(', ')
      end
    end

    # Displays a CMS reference attribute on an edit page.
    #
    # @param [Obj] object the cms object with a reference attribute
    # @param [String] attribute_name the name of the reference attribute
    # @param [Hash] options html options passed to the tag method
    def cms_edit_reference(object, attribute_name, options = {})
      reference = object.send(attribute_name)

      cms_tag(:div, object, attribute_name, options) do
        if reference
          "#{reference.name} (#{reference.id})"
        end
      end
    end

    # Displays a CMS referencelist attribute on an edit page and provides data for the referencelist
    # JavaScript editor.
    #
    # @param [Obj] object the cms object with a referencelist attribute
    # @param [String] attribute_name the name of the referencelist attribute
    # @param [Hash] options html options passed to the tag method
    def cms_edit_referencelist(object, attribute_name, options = {})
      reference_list = object.send(attribute_name)

      cms_tag(:div, object, attribute_name, options) do
        out = ''.html_safe

        out << content_tag(:ul) do
          html = ''.html_safe

          reference_list.each do |reference|
            html << content_tag(:li, 'data-name' => reference.name, 'data-id' => reference.id) do
              "#{reference.name} (#{reference.id})"
            end
          end

          html
        end

        out << button_tag(class: 'editing-button editing-green mediabrowser-open') do
          content_tag(:i, '', class: 'editing-icon editing-icon-search')
        end

        out
      end
    end

    def cms_edit_linklist(object, attribute_name, options = {})
      linklist = object.send(attribute_name)

      cms_tag(:div, object, attribute_name, options) do
        out = ''.html_safe

        out << content_tag(:ul) do
          html = ''.html_safe

          linklist.each do |link|
            url = if link.internal?
              "/#{link.obj.id}"
            else
              link.url
            end

            html << content_tag(:li, link.title, 'data-title' => link.title, 'data-url' => url)
          end

          html
        end

        out << button_tag(class: 'editing-button editing-green add-link') do
          content_tag(:i, '', class: 'editing-icon editing-icon-plus')
        end

        out
      end
    end
  end
end
