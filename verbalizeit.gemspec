# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verbalizeit/version'

Gem::Specification.new do |spec|
  spec.name          = "verbalizeit"
  spec.version       = Verbalizeit::VERSION
  spec.authors       = ["Nathanael Burt"]
  spec.email         = ["nathanael.burt@gmail.com"]
  spec.summary       = %q{Wrapper for VerbalizeIt's V2 API.}
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "webmock", "~> 1.20.4"
  spec.add_development_dependency "vcr", "~> 2.9.3"
  spec.add_development_dependency "dotenv", "~> 1.0.2"
  spec.add_development_dependency "pry", "~> 0.10.1"
  spec.add_runtime_dependency "typhoeus", "~> 0.6.9"
end
