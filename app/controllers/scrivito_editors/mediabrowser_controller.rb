module ScrivitoEditors
  class MediabrowserController < ApplicationController
    # Return JSON responses without layout information.
    layout false

    # Renders the mediabrowser modal and returns it in a JSON response.
    def modal
      render json: { content: render_to_string }
    end

    # Render a JSON response that holds the mediabrowser inspector markup. The inspector either
    # renders the details view for the selected object, or a fallback view that is located under
    # 'app/views/obj/details'.
    def inspector
      @obj = Obj.find(params[:id])

      options = {
        layout: 'scrivito_editors/mediabrowser/inspector',
      }

      content = begin
        render_to_string(details_view_template(@obj), options)
      rescue ActionView::MissingTemplate
        render_to_string('scrivito_editors/obj/details', options)
      end

      render json: { content: content }
    end

    private

    def details_view_template(obj)
      "#{obj.obj_class_name.underscore}/details"
    end
  end
end
