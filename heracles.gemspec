# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'heracles/version'

Gem::Specification.new do |gem|
  gem.authors       = [
    "Donald Brower",
    "Jeremy Friesen",
    "Rajesh Balekai"
  ]
  gem.email         = [
    "jeremy.n.friesen@gmail.com"
  ]
  gem.description   = %q{A Workflow Manager with a Hydra Project Leaning.}
  gem.summary       = %q{A Workflow Manager with a Hydra Project Leaning.}
  gem.homepage      = "https://github.com/ndlib/heracles"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "heracles"
  gem.require_paths = ["lib"]
  gem.version       = Heracles::VERSION

  gem.add_dependency "rails", "~> 3.2.11"
  gem.add_dependency "method_decorators"
  gem.add_dependency 'redis-store'
  gem.add_dependency 'resque'
  gem.add_dependency 'morphine'
  gem.add_dependency 'resque-ensure-connected'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'xpath'
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "capybara"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "factory_girl_rails"
  gem.add_development_dependency 'rspec-given', '~>1.6'
  gem.add_development_dependency 'rspec-on-rails-matchers'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'resque_spec'
  gem.add_development_dependency 'database_cleaner'
  gem.add_development_dependency 'rr'
  gem.add_development_dependency 'ndlib-on-rspec'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'timecop'
  gem.add_development_dependency 'webmock'

end
