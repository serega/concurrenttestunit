require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Demonstrate unit test concurrent execution'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.test_files = ['test/runsuitesconcurrently.rb', 'test/runtestsconcurrently.rb']
  t.verbose = true
end


