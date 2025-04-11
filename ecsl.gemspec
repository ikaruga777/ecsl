# frozen_string_literal: true

require_relative "lib/ecsl/version"

Gem::Specification.new do |spec|
  spec.name = "ecsl"
  spec.version = Ecsl::VERSION
  spec.authors = ["ikaruga"]
  spec.email = ["ikaruga777@gmail.com"]

  spec.summary       = "ECS Exec helper library"
  spec.description   = "A helper library for ECS Exec command"
  spec.homepage      = "https://github.com/ikaruga777/ecsl"
  spec.license       = "MIT"

  spec.files         = Dir.glob("lib/**/*.rb") + Dir.glob("exe/**/*")
  spec.bindir        = "exe"
  spec.executables   = ["ecsl"]
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-ecs"
  spec.add_dependency "tty-prompt"
  spec.add_dependency "json"
  spec.add_dependency "open3"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
