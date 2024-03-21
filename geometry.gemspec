# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
    spec = s
  s.name        = "geometry"
    spec.version	= '6.6'
  s.authors     = ["Brandon Fosdick"]
  s.email       = ["bfoz@bfoz.net"]
  s.homepage    = "http://github.com/bfoz/geometry"
  s.summary     = %q{Geometric primitives and algoritms}
  s.description = %q{Geometric primitives and algorithms for Ruby}

  s.rubyforge_project = "geometry"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.0'

    spec.add_development_dependency "bundler", "~> 2"
    spec.add_development_dependency "rake", "~> 13"
end
