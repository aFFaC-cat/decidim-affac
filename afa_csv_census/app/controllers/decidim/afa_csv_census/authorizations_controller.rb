# frozen_string_literal: true

module Decidim
  module AfaCsvCensus
    class AuthorizationsController < Decidim::Verifications::AuthorizationsController
      private

      def handler
        @handler ||= AfaCsvCensusAuthorizationHandler.from_params(handler_params)
      end
    end
  end
end
