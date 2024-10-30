# frozen_string_literal: true

Decidim::Verifications.register_workflow(:afas_csv_census_authorization_handler) do |workflow|
  workflow.engine = Decidim::CustomCsvCensus::Engine
  workflow.admin_engine = Decidim::CustomCsvCensus::AdminEngine
end
