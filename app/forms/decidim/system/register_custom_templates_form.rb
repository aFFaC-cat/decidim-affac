# frozen_string_literal: true

require "decidim/translatable_attributes"

module Decidim
  module System
    # A form object used to create organizations from the system dashboard.
    #
    class RegisterCustomTemplatesForm < UpdateOrganizationForm
      include JsonbAttributes
      mimic :organization

      attribute :template_id
      attribute :organization_admin_email, String
      attribute :organization_admin_name, String
      attribute :name, String
      attribute :reference_prefix

      validates :organization_admin_email, :organization_admin_name, :reference_prefix, :name, :host, presence: true

      def default_locale
        template.fields&.dig("organization", "default_locale") || Decidim.default_locale
      end

      def available_locales
        template.fields&.dig("organization", "available_locales") || Decidim.available_locales
      end

      def fields(field)
        template.fields&.dig("organization", field)
      end

      def users_registration_mode
        fields("users_registration_mode")
      end

      def template
        @template ||= OrganizationTemplates.new(template_id)
      end
    end
  end
end
