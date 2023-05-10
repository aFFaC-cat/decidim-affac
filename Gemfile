# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "0.25.2"

gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"
# bug in version 1.9
gem "i18n", "~> 1.8.1"

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-custom_csv_census", git: "https://github.com/Platoniq/decidim-verifications-custom_csv_census", branch: "release/0.25-stable"
gem "decidim-decidim_awesome", "~> 0.8"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: "release/0.25-stable"


group :development, :test do
  gem "faker", "~> 2.14"
  gem "rubocop-faker"

  gem "byebug"

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "listen", "~> 3.1.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console"

  gem "capistrano", "~> 3.14"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rails-console"
  gem "capistrano-rbenv"
end

group :production do
  gem "daemons", "~> 1.3"
  gem "figaro", "~> 1.2"
  gem "passenger", "~> 6.0"
  gem "sidekiq", "~> 6.0"
  gem "sidekiq-cron"
end
