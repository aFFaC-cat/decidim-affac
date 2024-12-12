# frozen_string_literal: true

Decidim::Verifications.register_workflow(:afa_csv_census_authorization_handler) do |workflow|
  workflow.engine = Decidim::AfaCsvCensus::Engine
  workflow.admin_engine = Decidim::AfaCsvCensus::AdminEngine
end
