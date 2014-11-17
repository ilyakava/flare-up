$:.push File.expand_path('../lib', __FILE__)
require 'flare_up/version'

Gem::Specification.new do |s|
  s.name        = 'flare-up'
  s.version     = FlareUp::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Robert Slifka']
  s.homepage    = 'http://www.github.com/sharethrough/flare-up'
  s.summary     = %q{Command-line access to bulk data loading via Redshift's CREATE TABLE, COPY, and DROP TABLE commands.}
  s.description = %q{Flare-up makes Redshift COPY scriptable by providing CLI access to the Redshift COPY command, with handy access to pretty printed errors as well. It also includes the CREATE TABLE and DROP TABLE commands.}

  s.add_dependency('pg', '~> 0.17')
  s.add_dependency('thor', '~> 0.19')

  s.add_development_dependency('rake', '~> 10.0')
  s.add_development_dependency('rspec', '~> 3.0')
  s.add_development_dependency('rspec-its', '~> 1.0')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)
end
