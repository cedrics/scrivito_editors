require 'jquery-ui-rails'
require 'scrivito_resourcebrowser'

module ScrivitoEditors
  class Engine < ::Rails::Engine
    isolate_namespace ScrivitoEditors

    initializer "my_gem.view_helpers" do
      ActionView::Base.send :include, TagHelper
    end
  end
end
