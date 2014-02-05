require File.expand_path('../lib/callcredit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_runtime_dependency 'faraday'
  gem.add_runtime_dependency 'faraday_middleware'
  gem.add_runtime_dependency 'multi_xml'
  gem.add_runtime_dependency 'nokogiri'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'

  gem.authors = ['Grey Baker']
  gem.description = %q{Ruby wrapper for Callcredit's CallValidate API}
  gem.email = ['grey@gocardless.com']
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/gocardless/callcredit-ruby'
  gem.name = 'callcredit'
  gem.require_paths = ['lib']
  gem.summary = %q{Ruby wrapper for Callcredit's CallValidate API}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Callcredit::VERSION.dup
end
