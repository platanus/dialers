# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dialers/version"

Gem::Specification.new do |spec|
  spec.name          = "dialers"
  spec.version       = Dialers::VERSION
  spec.authors       = ["juliogarciag"]
  spec.email         = ["julioggonz@gmail.com"]

  spec.summary       = "Api Wrappers for Ruby"
  spec.description   = "Api Wrappers for Ruby"
  spec.homepage      = "https://github.com/platanus/dialers"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.9"
  spec.add_dependency "faraday_middleware", "~> 0.9"
  spec.add_dependency "faraday-conductivity", "~> 0.3"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "guard", "~> 2.13"
  spec.add_development_dependency "guard-rspec", "~> 4.6"
  spec.add_development_dependency "rspec-nc", "~> 0.2"
  spec.add_development_dependency "rspec-legacy_formatters", "~> 1.0"
end
