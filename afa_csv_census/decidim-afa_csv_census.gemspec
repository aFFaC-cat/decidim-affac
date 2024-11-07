# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "decidim-afa_csv_census"
  s.version = "0.2.0"

  s.require_paths = ["lib"]
  s.authors = ["Pokecode"]
  s.description = "Decidim verifications via uploaded CSV with configurable data."
  s.email = ["info@pokecode.net"]
  s.licenses = ["AGPL-3.0"]
  s.summary = "A decidim afa_csv_census module"
  s.files = Dir["{app,config,lib,vendor,db}/**/*"]

  s.metadata["rubygems_mfa_required"] = "true"
  s.required_ruby_version = ">= 2.7"
end
