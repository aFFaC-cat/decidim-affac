# frozen_string_literal: true

module Decidim
  module AfaCsvCensus
    # Provides information about the current status of the census data
    class Status < CustomCsvCensus::Status
      # Returns the number of authorizations for a given organization census
      def authorizations_count
        @authorizations_count ||= Decidim::Verifications::Authorizations.new(
          organization: @organization,
          name: "afa_csv_census_authorization_handler"
        ).count
      end
    end
  end
end
