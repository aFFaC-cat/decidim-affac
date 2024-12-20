# frozen_string_literal: true

require "decidim/afa_csv_census/admin"
require "decidim/afa_csv_census/engine"
require "decidim/afa_csv_census/admin_engine"
require "decidim/afa_csv_census/workflow"

module Decidim
  module AfaCsvCensus
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :col_sep, :fields

      def initialize
        @col_sep = ","
        @fields = {}
      end
    end

    autoload :CustomFields, "decidim/custom_csv_census/custom_fields"
  end
end
