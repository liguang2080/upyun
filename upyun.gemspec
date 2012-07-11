# -*- encoding: utf-8 -*-
require File.expand_path('../lib/upyun/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["lg2046"]
  gem.email         = ["lg2046@gmail.com"]
  gem.description   = %q{又拍云存储ruby api}
  gem.summary       = %q{又拍云存储ruby api}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "upyun"
  gem.require_paths = ["lib"]
  gem.version       = Upyun::VERSION
end