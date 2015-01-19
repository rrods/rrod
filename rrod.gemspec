# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rrod/version'

Gem::Specification.new do |spec|
  spec.name          = "rrod"
  spec.version       = Rrod::VERSION
  spec.authors       = ["Adam Hunter"]
  spec.email         = ["adamhunter@me.com"]
  spec.description   = %[Riak Ruby Object Database]
  spec.summary       = %[A persistence layer for your ruby objects, powered by Riak]
  spec.homepage      = "https://github.com/adamhunter/rrod"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "riak-client",   "~> 1.4.2"
  spec.add_dependency "activemodel",   ">= 3.2"
  spec.add_dependency "activesupport", ">= 3.2"
  spec.add_dependency "american_date", ">= 1.1.0"

  # cli deps
  spec.add_dependency "thor", "~> 0.18"
  spec.add_dependency "pry",  "~> 0.9"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec",   "~> 3.1.0"

  spec.add_development_dependency "rake"
end
