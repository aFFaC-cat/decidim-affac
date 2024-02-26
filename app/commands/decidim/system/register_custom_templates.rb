# frozen_string_literal: true

module Decidim
  module System
    # A command with all the business logic when creating a new organization in
    # the system. It creates the organization and invites the admin to the
    # system.
    class RegisterCustomTemplates < Decidim::Command
      # Public: Initializes the command.
      #
      # form - A form object with the params.
      def initialize(form)
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form wasn't valid and we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        @organization = nil
        invite_form = nil
        invitation_failed = false

        transaction do
          @organization = create_organization
          CreateDefaultPages.call(@organization)
          PopulateHelp.call(@organization)
          CreateTemplateFields.call(@organization, form.template)
          invite_form = invite_user_form(@organization)
          invitation_failed = invite_form.invalid?
        end
        return broadcast(:invalid) if invitation_failed

        Decidim::InviteUser.call(invite_form) if @organization && invite_form

        broadcast(:ok)
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        broadcast(:invalid)
      end

      private

      attr_reader :form

      def create_organization
        Decidim::Organization.create!(
          name: form.name,
          host: form.host,
          reference_prefix: form.reference_prefix,
          available_locales: form.available_locales,
          default_locale: form.default_locale,
          users_registration_mode: form.users_registration_mode,
          force_users_to_authenticate_before_access_organization: form.force_users_to_authenticate_before_access_organization
        )
      end

      def invite_user_form(organization)
        Decidim::InviteUserForm.from_params(
          name: form.organization_admin_name,
          email: form.organization_admin_email,
          role: "admin",
          invitation_instructions: "organization_admin_invitation_instructions"
        ).with_context(
          current_user: form.current_user,
          current_organization: organization
        )
      end
    end
  end
end
