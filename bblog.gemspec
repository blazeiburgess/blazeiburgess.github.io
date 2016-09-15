# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "bblog"
  spec.version       = "0.1.0"
  spec.authors       = ["blaze.i.burgess@gmail.com"]
  spec.email         = ["blaze.i.burgess@gmail.com"]

  spec.summary       = %q{NOTE: Write a short summary, because Rubygems requires one.}
  spec.homepage      = "NOTE: Put your gem's website or public repo URL here."
  spec.license       = "GPLv3"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(_layouts|_includes|_sass|LICENSE|README)/i}) }

  spec.add_development_dependency "jekyll", "~> 3.2"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
