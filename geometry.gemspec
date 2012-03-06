# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "geometry/version"

Gem::Specification.new do |s|
  s.name        = "geometry"
  s.version     = Geometry::VERSION
  s.authors     = ["Brandon Fosdick"]
  s.email       = ["bfoz@bfoz.net"]
  s.homepage    = "http://github.com/bfoz/geometry"
  s.summary     = %q{Geometric primitives}
  s.description = %q{Geometric primitives for Ruby}

  s.rubyforge_project = "geometry"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
