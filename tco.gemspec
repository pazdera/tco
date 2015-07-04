# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tco/version"

Gem::Specification.new do |s|
  s.name        = "tco"
  s.version     = Tco::VERSION
  s.authors     = ["Radek Pazdera"]
  s.email       = ["radek@pazdera.co.uk"]
  s.summary     = %q{A tool and a library for terminal output colouring}
  s.description = %q{tco is a commandline tool and also a Ruby module that
                     allows its users to easily colourize the terminal
                     output of their bash scripts as well as Ruby programs.}
  s.homepage    = "https://github.com/pazdera/tco"
  s.license     = "MIT"

  s.rubyforge_project = "tco"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency 'bundler', '~> 1.5'
  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'rspec', '~> 0'
end
