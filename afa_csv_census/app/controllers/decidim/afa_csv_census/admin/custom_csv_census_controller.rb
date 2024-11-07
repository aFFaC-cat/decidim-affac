# frozen_string_literal: true

module Decidim
  module AfaCsvCensus
    module Admin
      class CustomCsvCensusController < Decidim::CustomCsvCensus::Admin::CustomCsvCensusController
        def create
          enforce_permission_to :create, :authorization

          @form = form(CsvForm).from_params(params)

          Decidim::CustomCsvCensus::Admin::CreateCensusData.call(@form) do
            on(:ok) do |report|
              flash[:notice] = t(".success", count: report.num_inserts, errors: report.num_invalid)
            end

            on(:invalid) do
              flash[:alert] = t(".error")
            end
          end

          redirect_to custom_csv_census_path
        end
      end
    end
  end
end
