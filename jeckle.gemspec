lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jeckle/version'

Gem::Specification.new do |spec|
  spec.name          = 'jeckle'
  spec.version       = Jeckle::VERSION
  spec.authors       = ['Tomas D\'Stefano', 'Brenno Costa']
  spec.email         = ['tomas_stefano@successoft.com', 'brennolncosta@gmail.com']
  spec.description   = %q{Simple module for build client APIs}
  spec.summary       = %q{Simple module for build client APIs}
  spec.homepage      = 'https://github.com/tomas-stefano/jeckle'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 4.0'
  spec.add_dependency 'faraday'
  spec.add_dependency 'virtus'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
