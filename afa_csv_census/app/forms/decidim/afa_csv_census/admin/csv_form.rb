# frozen_string_literal: true

module Decidim
  module AfaCsvCensus
    module Admin
      # A form to temporaly upload csv census data
      class CsvForm < Decidim::CustomCsvCensus::Admin::CsvForm
        def csv_data
          @csv_data ||= CsvData.new(file, current_organization)
        end
      end
    end
  end
end
