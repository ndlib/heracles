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

  gem.add_dependency "rails", "~> 3.2.7"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "capybara"
end
