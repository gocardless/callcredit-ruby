require File.expand_path('../lib/callcredit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_runtime_dependency 'faraday_middleware',  '>= 0.8.2', '< 0.13'
  gem.add_runtime_dependency 'multi_xml',           '~> 0.5.1'
  gem.add_runtime_dependency 'nokogiri',            '~> 1.4'
  gem.add_runtime_dependency 'unicode_utils',       '~> 1.4.0'

  gem.add_development_dependency 'rspec',           '~> 3.0.0'
  gem.add_development_dependency 'webmock',         '~> 3.0.1'
  gem.add_development_dependency 'rubocop'

  gem.authors = ['Grey Baker']
  gem.description = "Ruby wrapper for Callcredit's CallValidate API"
  gem.email = ['grey@gocardless.com']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/gocardless/callcredit-ruby'
  gem.name = 'callcredit'
  gem.require_paths = ['lib']
  gem.summary = "Ruby wrapper for Callcredit's CallValidate API"
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Callcredit::VERSION.dup
end
