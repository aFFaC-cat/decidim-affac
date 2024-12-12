# frozen_string_literal: true

module Decidim
  module AfaCsvCensus
    # An AuthorizationHandler that uses information uploaded from a CSV file
    # to authorize against.
    class AfaCsvCensusAuthorizationHandler < AuthorizationHandler
      def search_fields
        @search_fields ||= fields.select { |_k, options| options[:search] }
      end

      def search_keys
        search_fields.keys
      end

      def self.fields
        Decidim::AfaCsvCensus.configuration.fields
      end

      def fields
        self.class.fields
      end

      fields.each do |name, options|
        attribute name, options[:type]
        validates_presence_of name
        validates_format_of name, with: options[:format], message: I18n.t("errors.messages.#{name}_format") if options[:type] == String && options[:format]
      end

      validate :user_must_be_found_in_census

      def unique_id
        CustomCsvCensus::CensusDatum.encode(search_attributes)
      end

      def metadata
        metadata_fields = fields.reject { |_k, options| options[:encoded] }
        attributes.slice(*metadata_fields.keys).transform_values(&:to_s)
      end

      private

      def search_attributes
        attributes.slice(*search_keys).to_h { |key, val| [fields[key.to_sym][:column] || key, val] }
      end

      def user_must_be_found_in_census
        return if errors.any? || census_for_user

        search_keys.each do |field|
          errors.add(field, I18n.t("errors.messages.not_found"))
        end
      end

      def census_for_user
        return unless search_attributes.present?

        @census_for_user ||= CustomCsvCensus::CensusDatum.search(user.organization, search_attributes)
      end
    end
  end
end
