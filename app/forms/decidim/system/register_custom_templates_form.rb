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
      attribute :available_locales, Array

      attribute :users_registration_mode, String
      attribute :force_users_to_authenticate_before_access_organization, Boolean

      validates :organization_admin_email, :organization_admin_name, :reference_prefix, :name, :host, presence: true

      def default_locale
        template.template.dig(:organization, :default_locale)
      end

      def template
        @template ||= OrganizationTemplates.new(template_id)
      end
    end
  end
end
