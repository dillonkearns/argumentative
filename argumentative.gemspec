require File.expand_path("../lib/argumentative/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dillon Kearns"]
  gem.email         = ["dillon@dillonkearns.com"]
  gem.description   = "Flexible argument processing in a readable, declarative style!"
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/dillonkearns/argumentative"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "argumentative"
  gem.require_paths = ['lib']
  gem.version       = Argumentative::VERSION

  gem.required_ruby_version = ">=1.9.3"

  gem.add_development_dependency "rake", "~> 10.0.3"
  gem.add_development_dependency "minitest", "~> 4.6.2"
  gem.add_development_dependency "minitest-reporters"
  gem.add_development_dependency "mocha", "~> 0.13.2"
  gem.add_development_dependency "guard-minitest"
  gem.add_development_dependency "growl"
  gem.add_development_dependency "rb-fsevent"
  gem.add_development_dependency "coveralls"
end
