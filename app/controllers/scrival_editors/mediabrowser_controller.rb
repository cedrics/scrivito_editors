module ScrivalEditors
  class MediabrowserController < ApplicationController
    # Return JSON responses without layout information.
    layout false

    # Renders the mediabrowser modal and returns it in a JSON response.
    def modal
      render json: { content: render_to_string }
    end

    # Render a JSON response that holds the mediabrowser inspector markup. The inspector either
    # renders the edit view for the selected object, or a fallback edit view that is located under
    # 'app/views/obj/edit'.
    def inspector
      @obj = Obj.find(params[:id])

      options = {
        layout: 'scrival_editors/mediabrowser/inspector',
      }

      content = begin
        render_to_string(@obj.mediabrowser_edit_view_path, options)
      rescue ActionView::MissingTemplate
        render_to_string('scrival_editors/obj/edit', options)
      end

      render json: { content: content }
    end
  end
end
