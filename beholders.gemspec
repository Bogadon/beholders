# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "beholders/version"

Gem::Specification.new do |spec|
  spec.name          = "beholders"
  spec.version       = Beholders::VERSION
  spec.authors       = ["John Farey"]
  spec.email         = ["jfarey@yozu.co.uk", "kazimierzz@gmail.com"]

  spec.summary       = %q{Lightweight SRP encouraging observers for rails}
  spec.description   = %q{Add single responsibility observers to your rails models}
  spec.homepage      = "https://www.github.com/Bogadon"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 3"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_development_dependency "simplecov"
end
