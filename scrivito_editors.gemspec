$:.push File.expand_path('../lib', __FILE__)

require 'scrivito_editors/version'

Gem::Specification.new do |gem|
  gem.platform    = Gem::Platform::RUBY
  gem.name        = 'scrivito_editors'
  gem.version     = ScrivitoEditors::VERSION
  gem.summary     = 'Scrivito Editors'
  gem.description = 'Scrivito Editors'

  gem.required_ruby_version     = Gem::Requirement.new('>= 1.9')
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.8')

  gem.license = 'LGPL-3.0'

  gem.authors   = ['Scrivito']
  gem.email     = ['info@infopark.de']
  gem.homepage  = 'http://www.scrivito.com'

  gem.bindir      = 'bin'
  gem.executables = []
  gem.test_files  = []
  gem.files       = Dir[
    '{app,lib,vendor}/**/*',
    'LICENSE',
    'Rakefile',
    'README.md',
    'CHANGELOG.md',
  ]

  gem.add_dependency 'railties'
  gem.add_dependency 'coffee-rails'
  gem.add_dependency 'scrivito_sdk'
  gem.add_dependency 'scrivito_resourcebrowser'
  gem.add_dependency 'jquery-ui-rails'

  gem.add_development_dependency 'pry'
end
