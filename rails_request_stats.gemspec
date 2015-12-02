# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_request_stats/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_request_stats'
  spec.version       = RailsRequestStats::VERSION
  spec.authors       = ['Kevin Jalbert']
  spec.email         = ['kevin.j.jalbert@gmail.com']

  spec.summary       = 'Provides additional development statistics on Rails requests in logfile'
  spec.description   = 'Provides additional development statistics on Rails requests in logfile'
  spec.homepage      = 'https://github.com/kevinjalbert/rails_request_stats/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4.0'
  spec.add_development_dependency 'pry', '~> 0.10.0'

  spec.add_runtime_dependency 'rails', '>= 3.0.0'
end
