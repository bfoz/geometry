# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "geometry"
  s.version     = '3'
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

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
