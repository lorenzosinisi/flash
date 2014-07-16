# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "flash/version"

Gem::Specification.new do |gem|
  gem.name    = "flash"
  gem.license = "MIT"
  gem.version = Flash::VERSION

  gem.author   = ["Marius Colacioiu"]
  gem.email    = ["marius.colacioiu@gmail.com"]
  gem.homepage = "http://github.com/colmarius/flash"
  gem.summary  = %q{ Flash helps you run same commands on multiple projects all defined in the `.flash.yml` config. }

  gem.description = gem.summary

  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files = Dir["**/*"].select { |d| d =~ %r{^(README|bin/|lib/|spec/)} }
end
