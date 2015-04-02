# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitGraph/version'

Gem::Specification.new do |spec|
  spec.name          = "gitGraph"
  spec.version       = GitGraph::VERSION
  spec.authors       = ["caneroj1"]
  spec.email         = ["caneroj1@tcnj.edu"]
  spec.summary       = %q{Displays nice graphs of GitHub usage through a Rack App.}
  spec.description   = %q{Displays nice graphs of GitHub usage through a Rack App. Can help you analyze things like what languages you most frequently push in, etc.}
  spec.homepage      = "https://github.com/caneroj1/GitGraph"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
