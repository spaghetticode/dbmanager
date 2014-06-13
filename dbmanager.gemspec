# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dbmanager/version"

Gem::Specification.new do |s|
  s.name        = "dbmanager"
  s.version     = Dbmanager::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["andrea longhi"]
  s.email       = ["andrea.longhi@mikamai.com"]
  s.homepage    = "https://github.com/spaghetticode/dbmanager"
  s.summary     = %q{database manager}
  s.description = %q{helps manage db dumps and imports via rake tasks}

  s.rubyforge_project = "dbmanager"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  if RUBY_VERSION.to_f > 1.8
    s.add_dependency 'rails'
  else
    s.add_dependency 'rails', '~> 3'
    s.add_development_dependency 'listen', '1.3.1'
  end
  s.add_development_dependency 'rspec', '~> 2.12'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-cucumber'
end
