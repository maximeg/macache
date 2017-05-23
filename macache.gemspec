# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "macache/version"

Gem::Specification.new do |spec|
  spec.name = "macache"
  spec.version = Macache::VERSION
  spec.authors = ["Maxime Garcia"]
  spec.email = ["maxime.garcia@gmail.com"]

  spec.summary = "Efficient caching with Ruby & Redis."
  spec.description = spec.summary
  spec.homepage = "https://github.com/maximeg/macache"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.0.0"

  spec.files =
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "0.48.1"
end
