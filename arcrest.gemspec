lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arcrest/version'

Gem::Specification.new do |spec|
  spec.name          = 'arcrest'
  spec.version       = ArcREST::VERSION
  spec.authors       = ['Bruce Steedman']
  spec.email         = ['bruce.steedman@gmail.com']

  spec.summary       = 'Wrapper for ArcGIS REST API'
  spec.description   = 'Wrapper for ArcGIS REST API'
  spec.homepage      = 'https://github.com/MatzFan/arcrest'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 12.1'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'libnotify', '~> 0.9' # guard notifications
end
