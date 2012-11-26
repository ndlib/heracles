#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'yard/rake/yardoc_task'

namespace :doc do
  YARD::Rake::YardocTask.new(:app) do |t|
    t.files += [
      'app/**/*.rb',
      'spec/**/*_spec.rb',
      '-',
       "*.md",
       "*.mkd"
     ]
  end
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec, ["app:db:test:prepare"])

task :default => :spec
