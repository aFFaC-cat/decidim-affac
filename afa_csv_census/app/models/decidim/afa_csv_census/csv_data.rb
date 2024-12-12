# frozen_string_literal: true

require "csv"

module Decidim
  module AfaCsvCensus
    # Provides information about the current status of the census data
    class CsvData < Decidim::CustomCsvCensus::CsvData
      delegate :configuration, to: "Decidim::AfaCsvCensus"

      def headers
        @headers ||= CSV.open(@filepath, **options, &:first)&.headers
      end

      def columns
        headers.map { |h| header_to_column(h) } + [:decidim_organization_id, :created_at]
      end

      def header_to_column(header)
        configuration.fields[header.to_sym][:column] || header
      end
    end
  end
end
