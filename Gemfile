# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim.git', branch: 'release/0.22-stable' }

gem 'daemons'
gem 'delayed_job_active_record'
gem 'puma', '~> 4.0'
gem 'uglifier', '>= 1.3.0'
gem 'whenever'

gem 'geocoder', '~> 1.5.2'
gem 'figaro', '>= 1.1.1'
gem 'openssl'

gem 'decidim', DECIDIM_VERSION
gem 'decidim-consultations', DECIDIM_VERSION
gem 'decidim-verifications-custom_csv_census', git: "https://github.com/CodiTramuntana/decidim-verifications-custom_csv_census.git", tag: "v0.0.2"
gem "decidim-term_customizer", git: "https://github.com/CodiTramuntana/decidim-module-term_customizer.git"

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug', platform: :mri
end

group :development do
  gem 'decidim-dev', DECIDIM_VERSION
  gem 'faker', '~> 1.8.4'
  gem 'letter_opener_web', '~> 1.3.0'
  gem 'listen', '~> 3.1.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
end
