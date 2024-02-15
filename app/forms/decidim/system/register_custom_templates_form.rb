# frozen_string_literal: true

require "decidim/translatable_attributes"

module Decidim
  module System
    # A form object used to create organizations from the system dashboard.
    #
    class RegisterCustomTemplatesForm < UpdateOrganizationForm
      include JsonbAttributes
      mimic :organization

      attribute :organization_admin_email, String
      attribute :organization_admin_name, String
      attribute :name, String

      validates :organization_admin_email, :organization_admin_name, :name, presence: true
    end
  end
end
