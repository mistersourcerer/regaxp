require_relative 'lib/regaxp/version'

Gem::Specification.new do |spec|
  spec.name          = "regaxp"
  spec.version       = Regaxp::VERSION
  spec.authors       = ["Ricardo Valeriano"]
  spec.email         = ["ricardo.valeriano@gmail.com"]

  spec.summary       = %q{TOY Regular Expression Engine in Pure Ruby}
  spec.description   = %q{TOY Regular Expression Engine in Pure Ruby}
  spec.homepage      = "https://github.com/mistersourcerer/regaxp"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mistersourcerer/regaxp"
  spec.metadata["changelog_uri"] = "https://github.com/mistersourcerer/regaxp/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk"
  spec.add_dependency "yard"
end
