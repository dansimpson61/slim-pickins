# frozen_string_literal: true

require 'rake/testtask'

# Run all tests
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

# Run only unit tests (helpers)
Rake::TestTask.new('test:unit') do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList[
    'test/component_helpers_test.rb',
    'test/pattern_helpers_test.rb',
    'test/form_helpers_test.rb',
    'test/stimulus_helpers_test.rb'
  ]
  t.verbose = true
end

# Run only sampler tests
Rake::TestTask.new('test:sampler') do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/sampler_app_test.rb']
  t.verbose = true
end

# Run only documentation tests
Rake::TestTask.new('test:docs') do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/documentation_test.rb']
  t.verbose = true
end

# Run integration tests
Rake::TestTask.new('test:integration') do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/integration_test.rb']
  t.verbose = true
end

task default: :test

desc "Run the example app"
task :example do
  exec "cd example_app && bundle exec rackup -p 9292"
end

desc "Run the sampler app"
task :sampler do
  exec "cd sampler && bundle exec rackup -p 9393"
end

desc "Build gem"
task :build do
  system "gem build slim-pickins.gemspec"
end

desc "Install gem locally"
task install: :build do
  system "gem install ./slim-pickins-*.gem"
end

desc "Run all apps for development"
task :dev do
  puts "Starting apps..."
  puts "Example app: http://localhost:9292"
  puts "Sampler app: http://localhost:9393"
  puts ""
  puts "Press Ctrl+C to stop"
  
  # This would require foreman or similar, so just show instructions
  puts ""
  puts "Run in separate terminals:"
  puts "  rake example"
  puts "  rake sampler"
end
