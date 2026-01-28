# frozen_string_literal: true

require_relative "lib/slim_pickins/version"

Gem::Specification.new do |spec|
  spec.name = "slim-pickins"
  spec.version = SlimPickins::VERSION
  spec.authors = ["Detailed Dan"]
  spec.email = ["dan@example.com"]

  spec.summary = "A modest MVP UI helper library for Sinatra/Slim."
  spec.description = "Expression over specification. Joy over ceremony. A collection of UI helpers."
  spec.homepage = "https://github.com/example/slim-pickins"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.files = Dir.chdir(__dir__) do
    Dir["{assets,lib}/**/*", "LICENSE", "README.md"]
  end

  spec.add_dependency "sinatra", "~> 3.0"
  spec.add_dependency "slim", "~> 5.0"
end
