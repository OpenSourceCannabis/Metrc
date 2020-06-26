lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'Metrc/version'

Gem::Specification.new do |spec|
  spec.name          = 'Metrc'
  spec.version       = Metrc::VERSION
  spec.authors       = ['Emanuele Tozzato', 'Carlos Betancourt Carrero']
  spec.email         = ['etozzato@gmail.com', 'cbetancourt@artemisag.com']

  spec.summary       = 'Pull and push lab data between a LIMS and Metrc'
  spec.description   = 'A simple gem to pull lab tests and push results to Metrc'
  spec.homepage      = 'https://420tech.org'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler'
  spec.add_dependency 'httparty'
  spec.add_dependency 'rake'
  spec.add_dependency 'rspec'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'webmock'
end
