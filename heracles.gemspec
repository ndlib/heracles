# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "heracles"
  s.version = Heracles::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = [
    "Jeremy Friesen",
    "Donald Brower",
    "Rajesh Balekai",
  ]

  s.email = [
    "jeremy.n.friesen@gmail.com"
  ]
  s.homepage = "https://github.com/ndlib/heracles"

  s.summary = "A Workflow Manager with a Hydra Project Leaning."
  s.description = "Insert Heracles description."

  s.required_rubygems_version = "> 1.3.6"

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files`.split("\n").map{|f|
    f =~ /^bin\/(.*)/ ? $1 : nil
  }.compact
  s.require_path = 'lib'

end