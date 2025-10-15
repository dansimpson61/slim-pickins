# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task default: :test

desc "Run the example app"
task :example do
  exec "cd example_app && bundle exec rackup -p 9292"
end

desc "Build gem"
task :build do
  system "gem build slim-pickins.gemspec"
end

desc "Install gem locally"
task install: :build do
  system "gem install ./slim-pickins-*.gem"
end
