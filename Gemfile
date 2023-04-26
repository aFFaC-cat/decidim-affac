# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_BRANCH = "release/0.27-stable"
DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", branch: DECIDIM_BRANCH }.freeze

gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"
# bug in version 1.9
gem "i18n", "~> 1.8.1"

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-decidim_awesome", git: "https://github.com/decidim-ice/decidim-module-decidim_awesome", branch: "main"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: "master"
# gem "decidim-verifications-custom_csv_census", git: "https://github.com/Platoniq/decidim-verifications-custom_csv_census", branch: "chore/upgrade-0.25"

group :development, :test do
  gem "faker", "~> 2.14"
  gem "rubocop-faker"

  gem "byebug"

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"

  gem "capistrano", "~> 3.15"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rails-console"
  gem "capistrano-rbenv"
  gem "capistrano-sidekiq"
end

group :production do
  gem "daemons", "~> 1.3"
  gem "figaro", "~> 1.2"
  gem "passenger", "~> 6.0"
  gem "sidekiq", "~> 6.0"
  gem "sidekiq-cron"
end
