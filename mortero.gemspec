lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mortero/version'

Gem::Specification.new do |spec|
  spec.name          = "mortero"
  spec.version       = Mortero::VERSION
  spec.authors       = ["apux"]
  spec.email         = ["azarel.doroteo@logicalbricks.com"]
  spec.summary       = %q{Convert simple hashes into nested attributes hashes}
  spec.description   = %q{Merge an array of hashes to grouped hashes with nested attributes (usefull when importing from excel)}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
end
