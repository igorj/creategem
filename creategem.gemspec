$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'creategem/version'

Gem::Specification.new do |spec|
  spec.name          = "creategem"
  spec.version       = Creategem::VERSION
  spec.authors       = ["Igor Jancev"]
  spec.email         = ["igor@masterybits.com"]
  spec.summary       = %q{Creategem creates a scaffold project for new gems}
  spec.description   = %q{Creategem creates a scaffold project for new gems. You can choose between Github and Bitbucket,
                          Rubygems or Geminabox, with executable or without, etc.}
  spec.homepage      = "https://github.com/igorj/creategem"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
  spec.add_development_dependency "gem-release", "~> 0.7"
  spec.add_development_dependency "geminabox", "~> 0.13"

  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "git", "~> 1.3"
end
