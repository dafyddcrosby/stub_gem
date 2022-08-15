# frozen_string_literal: true

require_relative "lib/stub_gem/version"

Gem::Specification.new do |spec|
  spec.name = "stub_gem"
  spec.required_ruby_version = ">= 2.6.0"
  spec.version     = StubGem::VERSION
  spec.platform    = Gem::Platform::RUBY
  spec.authors     = ["David Crosby"]
  spec.homepage    = "https://daveops.net"
  spec.summary     = "Simple program to stub out a Ruby project how I like it"
  spec.description = spec.summary
  spec.license     = "MIT"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test)/|\.(?:git))})
    end
  end
  spec.bindir = "exe"
  spec.executables = ["stub_gem"]
end
