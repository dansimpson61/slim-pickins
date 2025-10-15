# frozen_string_literal: true

require_relative 'lib/slim_pickins/version'

Gem::Specification.new do |spec|
  spec.name          = 'slim-pickins'
  spec.version       = SlimPickins::VERSION
  spec.authors       = ['Slim-Pickins Contributors']
  spec.email         = ['hello@slim-pickins.dev']
  
  spec.summary       = 'Ultra-lightweight UI framework for Ruby, Sinatra, Slim, and StimulusJS'
  spec.description   = 'Expression over specification. Build web UIs with clean templates that hide HTML/JS complexity behind elegant Ruby helpers. As good as bread.'
  spec.homepage      = 'https://github.com/slim-pickins/slim-pickins'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'
  
  spec.metadata = {
    'bug_tracker_uri'   => 'https://github.com/slim-pickins/slim-pickins/issues',
    'changelog_uri'     => 'https://github.com/slim-pickins/slim-pickins/blob/main/CHANGELOG.md',
    'source_code_uri'   => 'https://github.com/slim-pickins/slim-pickins',
    'homepage_uri'      => spec.homepage,
  }
  
  spec.files = Dir[
    'lib/**/*.rb',
    'LICENSE',
    'README.md',
    'PHILOSOPHY.md'
  ]
  
  spec.require_paths = ['lib']
  
  # Runtime dependencies
  spec.add_dependency 'sinatra', '~> 3.0'
  spec.add_dependency 'slim', '~> 5.0'
  
  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rack-test', '~> 2.0'
  spec.add_development_dependency 'pry', '~> 0.14'
end
