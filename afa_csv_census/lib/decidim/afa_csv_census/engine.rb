# frozen_string_literal: true

require "rails"
require "decidim/verifications"

module Decidim
  module AfaCsvCensus
    # This is the engine that runs on the public interface of custom_csv_census.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::AfaCsvCensus

      routes do
        resources :authorizations, only: [:new, :create, :index]

        root to: "authorizations#new"
      end
    end
  end
end
