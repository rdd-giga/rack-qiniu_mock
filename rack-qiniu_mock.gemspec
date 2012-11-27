# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/qiniu_mock/version'

Gem::Specification.new do |gem|
  gem.name          = "rack-qiniu_mock"
  gem.version       = Rack::QiniuMock::VERSION
  gem.authors       = ["LI Daobing"]
  gem.email         = ["lidaobing@gmail.com"]
  gem.description   = %q{qiniutek.com image resize service mocker}
  gem.summary       = %q{mock qiniutek.com image resize service so you can use image resize service under development}
  gem.homepage      = "https://github.com/lidaobing/qiniu_mock"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "rack"
  gem.add_dependency "mini_magick"
end
