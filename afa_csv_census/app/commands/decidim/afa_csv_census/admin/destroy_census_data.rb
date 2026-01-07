# frozen_string_literal: true

module Decidim
  module AfaCsvCensus
    module Admin
      class DestroyCensusData < Decidim::CustomCsvCensus::Admin::DestroyCensusData
        def destroy_authorizations
          @authorizations_count = Decidim::Verifications::Authorizations.new(
            organization: organization,
            name: "afa_csv_census_authorization_handler"
          ).query.delete_all
        end
      end
    end
  end
end
