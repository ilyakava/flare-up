$:.push File.expand_path('../lib', __FILE__)
require 'flare_up/version'

Gem::Specification.new do |s|
  s.name        = 'flare-up'
  s.version     = FlareUp::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Robert Slifka']
  s.homepage    = 'http://www.github.com/rslifka/flareup'
  s.summary     = %q{I will fill this in momentarily.}
  s.description = %q{I will fill this in momentarily.}

  s.add_dependency('pg', '~> 0.17')

  s.add_development_dependency('rake', '~> 10.0')
  s.add_development_dependency('rspec', '~> 3.0')
  s.add_development_dependency('rspec-its', '~> 1.0')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)
end
