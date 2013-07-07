# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tco/version"

Gem::Specification.new do |s|
  s.name        = "tco"
  s.version     = Tco::VERSION
  s.authors     = ["Radek Pazdera"]
  s.email       = ["radek@pazdera.co.uk"]
  s.homepage    = "http://linuxwell.com"
  s.summary     = %q{A tool and a library for terminal output colouring}
  s.description = %q{tco is a commandline tool and also a Ruby module that
                     allows its users to easily colourize the terminal
                     output of their bash scripts as well as Ruby programs.}

  s.rubyforge_project = "tco"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rdoc'
end
