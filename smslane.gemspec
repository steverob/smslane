# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smslane/version'

Gem::Specification.new do |spec|
  spec.name          = "smslane"
  spec.version       = Smslane::VERSION
  spec.authors       = ["Steve Robinson"]
  spec.email         = ["steve.rob@me.com"]
  spec.description   = %q{Wrapper gem for the Smslane.com HTTP API}
  spec.summary       = %q{A simple to use gem that enables developers to integrate Smslane.com's HTTP API with their applications and access the Bulk SMS service. Balance Check, Multiple recipient and delivery report features are all supported.}
  spec.homepage      = "https://github.com/steverob/smslane"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"

  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
