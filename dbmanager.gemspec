# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dbmanager/version"

Gem::Specification.new do |s|
  s.name        = "dbmanager"
  s.version     = Dbmanager::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["andrea longhi"]
  s.email       = ["andrea.longhi@mikamai.com"]
  s.homepage    = ""
  s.summary     = %q{database manager}
  s.description = %q{helps manage db dumps and imports via rake tasks}

  s.rubyforge_project = "dbmanager"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
end
