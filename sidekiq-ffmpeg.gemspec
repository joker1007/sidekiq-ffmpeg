# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/ffmpeg/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-ffmpeg"
  spec.version       = Sidekiq::Ffmpeg::VERSION
  spec.authors       = ["joker1007"]
  spec.email         = ["kakyoin.hierophant@gmail.com"]
  spec.description   = %q{easier way to use ffmpeg in sidekiq}
  spec.summary       = %q{easier way to use ffmpeg in sidekiq}
  spec.homepage      = "https://github.com/joker1007/sidekiq-ffmpeg"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency     "sidekiq", ">= 2.1", "< 4"
  spec.add_development_dependency "bundler", ">= 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "tapp"
  spec.add_development_dependency "coveralls"
end
