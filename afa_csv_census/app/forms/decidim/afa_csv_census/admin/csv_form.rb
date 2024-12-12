# frozen_string_literal: true

module Decidim
  module AfaCsvCensus
    module Admin
      # A form to temporaly upload csv census data
      class CsvForm < Decidim::CustomCsvCensus::Admin::CsvForm
        def csv_data
          @csv_data ||= CsvData.new(file, current_organization)
        end

        private

        def csv_must_be_readable
          csv_data.read
          return errors.add(:base, I18n.t("decidim.afa_csv_census.errors.no_headers", header_names: csv_data.fields.keys.join(", "))) if csv_data.headers.blank?

          unless csv_data.headers.count == csv_data.fields.keys.count
            errors.add(:base,
                              I18n.t("decidim.afa_csv_census.errors.wrong_number_columns", expected: csv_data.fields.keys.count, actual: csv_data.headers.count,
                                                                                           col_sep: csv_data.col_sep))
            return
          end

          wrong_headers = []
          csv_data.headers.each do |header|
            next if csv_data.fields.keys.include?(header)

            wrong_headers << header
          end

          if wrong_headers.present?
            errors.add(:base,
                       I18n.t("decidim.afa_csv_census.errors.unknown_headers", unknown_headers: wrong_headers.join(", "),
                                                                               header_names: csv_data.fields.keys.join(", ")))
          end

          if csv_data.errors.present?
            data_errors = []
            csv_data.errors.each do |error|
              data_errors << error.values_at.join("|")
            end
            errors.add(:base, I18n.t("decidim.afa_csv_census.errors.wrong_rows_data", rows_data: data_errors.join(", ")))
          end
        rescue CSV::MalformedCSVError
          errors.add(:file, :invalid)
        end
      end
    end
  end
end
