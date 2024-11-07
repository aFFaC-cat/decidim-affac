# frozen_string_literal: true

require "csv"

module Decidim
  module AfaCsvCensus
    # Provides information about the current status of the census data
    class CsvData < Decidim::CustomCsvCensus::CsvData
      delegate :configuration, to: "Decidim::AfaCsvCensus"
    end
  end
end
