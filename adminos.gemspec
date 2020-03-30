Gem::Specification.new do |gem|
  gem.name          = 'adminos'
  gem.version       = '1.0.0-rc.3'
  gem.authors       = ['RavWar', 'milushov', 'abuhtoyarov', 'SiebenSieben']
  gem.email         = ['studio@molinos.ru']
  gem.homepage      = 'https://gitlab.molinos.ru/global/adminos'
  gem.summary       = 'Adminos'
  gem.description   = 'A framework for creating admin dashboards'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep %r{^spec/}
  gem.require_paths = %w(lib)
  gem.bindir        = 'exe'
  gem.executables   = `git ls-files -- #{gem.bindir}/*`.split($/).map { |f| File.basename(f) }

  gem.add_dependency 'path'
  gem.add_dependency 'jquery-fileupload-rails'
  gem.add_dependency 'railties'
  gem.add_dependency 'dotenv-rails'
  gem.add_dependency 'slim-rails'
  gem.add_dependency 'friendly_id'
  gem.add_dependency 'babosa'
  gem.add_dependency 'simple_form'
  gem.add_dependency 'kaminari'
  gem.add_dependency 'devise'
  gem.add_dependency 'cancancan'
  gem.add_dependency 'cocoon'
  gem.add_dependency 'awesome_nested_set'
  gem.add_dependency 'ransack'

  gem.add_development_dependency 'm'
  gem.add_development_dependency 'rails'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'ammeter'
  gem.add_development_dependency 'simplecov'
end
