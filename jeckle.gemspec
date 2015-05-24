lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jeckle/version'

Gem::Specification.new do |spec|
  spec.name          = 'jeckle'
  spec.version       = Jeckle::VERSION
  spec.authors       = ['Tomas D\'Stefano', 'Brenno Costa']
  spec.email         = ['tomas_stefano@successoft.com', 'brennolncosta@gmail.com']
  spec.description   = %q{Simple module for building client APIs}
  spec.summary       = %q{Simple module for building client APIs}
  spec.homepage      = 'https://github.com/tomas-stefano/jeckle'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 4.0'
  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'virtus'

  spec.add_development_dependency 'bundler', '>= 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.2'

  case RUBY_ENGINE
  when 'rbx'
    spec.add_development_dependency 'rubinius-compiler'
    spec.add_development_dependency 'rubinius-debugger'
  when 'jruby', 'ruby'
    spec.add_development_dependency 'pry'

    if RUBY_VERSION >= '2.0.0'
      spec.add_development_dependency 'pry-byebug', '3.1.0'
    else
      spec.add_development_dependency 'pry-nav'
    end
  end
end
