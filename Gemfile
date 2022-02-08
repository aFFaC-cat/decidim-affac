# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

DECIDIM_VERSION = { git: 'https://github.com/Platoniq/decidim.git', branch: 'temp/0.24' }

gem 'whenever'
gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"
# bug in version 1.9
gem "i18n", "~> 1.8.1"

gem 'decidim', DECIDIM_VERSION
gem 'decidim-consultations', DECIDIM_VERSION
gem 'decidim-verifications-custom_csv_census', git: "https://github.com/CodiTramuntana/decidim-verifications-custom_csv_census.git", tag: "v0.0.2"
gem "decidim-term_customizer", git: "https://github.com/CodiTramuntana/decidim-module-term_customizer.git"
gem "decidim-decidim_awesome", "~> 0.7.2"

group :development, :test do
  gem 'byebug'

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
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
