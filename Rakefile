# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "unscoped_associations"
  gem.homepage = "http://github.com/markets/unscoped_associations"
  gem.license = "MIT"
  gem.summary = %Q{TODO: one-line summary of your gem}
  gem.description = %Q{TODO: longer description of your gem}
  gem.email = "srmarc.ai@gmail.com"
  gem.authors = ["markets"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

# Release tasks
namespace :release do
  desc "create a patch release, create tag and push to github"
  task :patch do
    Rake::Task['version:bump:patch'].invoke
    Rake::Task['gemspec'].invoke
    `git commit -am 'Regenerate gemspec'`
    Rake::Task['git:release'].invoke
  end

  desc "create a minor, create tag and push to github"
  task :minor do
    Rake::Task['version:bump:minor'].invoke
    Rake::Task['gemspec'].invoke
    `git commit -am 'Regenerate gemspec'`
    Rake::Task['git:release'].invoke
  end

  desc "create a major, create tag and push to github"
  task :major do
    Rake::Task['version:bump:major'].invoke
    Rake::Task['gemspec'].invoke
    `git commit -am 'Regenerate gemspec'`
    Rake::Task['git:release'].invoke
  end
end