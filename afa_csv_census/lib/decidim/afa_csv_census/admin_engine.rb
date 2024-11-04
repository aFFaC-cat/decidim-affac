# frozen_string_literal: true

module Decidim
  module AfaCsvCensus
    # This is the engine that runs on the public interface of `AfaCsvCensus`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::AfaCsvCensus::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :custom_csv_census, only: [:index, :create] do
          collection do
            delete :destroy
          end
        end

        root to: "custom_csv_census#index"
      end
    end
  end
end
