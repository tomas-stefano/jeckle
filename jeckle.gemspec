lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jeckle/version'

Gem::Specification.new do |spec|
  spec.name          = 'jeckle'
  spec.version       = Jeckle::VERSION
  spec.authors       = ['Tomas D\'Stefano', 'Brenno Costa']
  spec.email         = ['tomas_stefano@successoft.com', 'brennolncosta@gmail.com']
  spec.description   = 'Simple module for building client APIs'
  spec.summary       = 'Simple module for building client APIs'
  spec.homepage      = 'https://github.com/tomas-stefano/jeckle'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.0'

  spec.files         = Dir['lib/**/*', 'LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 6.0'
  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'virtus'

  spec.add_development_dependency 'bundler', '>= 2.0'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.12'
end
