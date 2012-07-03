require 'rubygems'
require 'rake'
require 'bundler'

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

Bundler::GemHelper.install_tasks
