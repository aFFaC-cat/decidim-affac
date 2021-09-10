# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

DECIDIM_VERSION = { git: 'https://github.com/CodiTramuntana/decidim.git', branch: 'release/0.24-stable' }

gem 'puma'
gem 'uglifier', '>= 1.3.0'
gem 'whenever'

gem 'openssl'

gem 'decidim', DECIDIM_VERSION
gem 'decidim-consultations', DECIDIM_VERSION
gem 'decidim-verifications-custom_csv_census', git: "https://github.com/CodiTramuntana/decidim-verifications-custom_csv_census.git", tag: "v0.0.2"
gem "decidim-term_customizer", git: "https://github.com/CodiTramuntana/decidim-module-term_customizer.git"

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
end

group :development do
  gem 'decidim-dev', DECIDIM_VERSION
  gem 'faker'
  gem 'letter_opener_web'
  gem 'listen', '~> 3.1.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'

  gem "capistrano", "~> 3.14"
  gem "capistrano-rails-console"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rbenv"
end

group :production do
  gem "daemons", "~> 1.3"
  gem "delayed_job_active_record", "~> 4.1"
  gem "figaro", "~> 1.2"
  gem "passenger", "~> 6.0"
end
