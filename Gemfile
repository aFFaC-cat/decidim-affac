# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "~> 0.27.9"

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-custom_csv_census", git: "https://github.com/Platoniq/decidim-verifications-custom_csv_census", branch: "master"
gem "decidim-decidim_awesome", git: "https://github.com/decidim-ice/decidim-module-decidim_awesome", branch: "backport-manual_verifications"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: "release/0.27-stable"

gem "decidim-afa_csv_census", path: "./afa_csv_census"

gem "bootsnap", "~> 1.7"
gem "deface", ">= 1.9"
gem "faraday"
gem "puma", ">= 5.0.0"
gem "wicked_pdf", "~> 2.1"

group :development, :test do
  gem "faker", "~> 2.14"
  gem "rubocop-faker"

  gem "byebug"

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"
end

group :production do
  gem "sidekiq"
  gem "sidekiq-cron"
end
