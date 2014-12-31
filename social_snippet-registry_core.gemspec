# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'social_snippet/registry_core/version'

Gem::Specification.new do |spec|
  spec.name          = "social_snippet-registry_core"
  spec.version       = SocialSnippet::RegistryCore::VERSION
  spec.authors       = ["Hiroyuki Sano"]
  spec.email         = ["sh19910711@gmail.com"]
  spec.summary       = %q{The server-side core classes for social-snippet-registry}
  spec.homepage      = "https://sspm.herokuapp.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9"

  spec.add_runtime_dependency "bundler"
  spec.add_runtime_dependency "rake"

  spec.add_runtime_dependency "padrino", "~> 0.12"
  spec.add_runtime_dependency "thin"
  spec.add_runtime_dependency "mongoid", "~> 4.0"
  spec.add_runtime_dependency "rack-parser"
  spec.add_runtime_dependency "rack-tracker"
  spec.add_runtime_dependency "slim"
  spec.add_runtime_dependency "dalli"

  spec.add_runtime_dependency "version_sorter"
  spec.add_runtime_dependency "octokit"
  spec.add_runtime_dependency "omniauth-github"
end
