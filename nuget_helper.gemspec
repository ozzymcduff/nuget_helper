# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nuget_helper/version'

Gem::Specification.new do |spec|
  spec.name          = "nuget_helper"
  spec.version       = NugetHelper::VERSION
  spec.authors       = ["Oskar Gewalli"]
  spec.email         = ["gewalli@gmail.com"]
  spec.summary       = %q{Helper Gem to simplify work with nuget.}
  spec.homepage      = "https://github.com/wallymathieu/nuget_helper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '>= 3.2'
  spec.add_dependency "nuget", '~> 3.4.4'
  spec.add_dependency 'semver2', '~> 3.4'
  spec.add_dependency 'nokogiri', '~> 1.5' # used to manipulate and read *nuspec files
  
end
