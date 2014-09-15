require 'jquery-ui-rails'
require 'scrivito_resourcebrowser'

module ScrivitoEditors
  class Engine < ::Rails::Engine
    isolate_namespace ScrivitoEditors

    initializer "scrivito_editors.cms_tag_helper" do
      ActionView::Base.send :include, CmsTagHelper
    end
  end
end
