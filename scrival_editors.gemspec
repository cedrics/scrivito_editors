$:.push File.expand_path('../lib', __FILE__)

require 'scrival_editors/version'

Gem::Specification.new do |gem|
  gem.platform    = Gem::Platform::RUBY
  gem.name        = 'scrival_editors'
  gem.version     = ScrivalEditors::VERSION
  gem.summary     = 'Scrival Editors'
  gem.description = 'Scrival Editors'

  gem.required_ruby_version     = Gem::Requirement.new('>= 1.9')
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.8')

  gem.license = 'LGPL-3.0'

  gem.authors   = ['Scrival']
  gem.email     = ['info@infopark.de']
  gem.homepage  = 'http://www.scrival.com'

  gem.bindir      = 'bin'
  gem.executables = []
  gem.test_files  = Dir['spec/**/*']
  gem.files       = Dir[
    '{app,config,lib,vendor}/**/*',
    'LICENSE',
    'Rakefile',
    'README.md',
    'CHANGELOG.md',
  ]

  gem.add_dependency 'railties'
  gem.add_dependency 'coffee-rails'
  gem.add_dependency 'scrival_sdk'
  gem.add_dependency 'jquery-ui-rails'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec-rails'
end
