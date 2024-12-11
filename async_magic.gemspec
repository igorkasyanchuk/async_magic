# frozen_string_literal: true

require_relative "lib/async_magic/version"

Gem::Specification.new do |spec|
  spec.name = "async_magic"
  spec.version = AsyncMagic::VERSION
  spec.authors = ["Igor Kasyanchuk"]
  spec.email = ["igorkasyanchuk@gmail.com"]

  spec.summary = "Simple async methods for Ruby, Ruby on Rails applications"
  spec.description = "Simple async methods for Ruby, Ruby on Rails applications"
  spec.homepage = "https://github.com/igorkasyanchuk/async_magic"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "concurrent-ruby"

  spec.add_development_dependency "rails"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "diff-lcs"
  spec.add_development_dependency "debug"
end
