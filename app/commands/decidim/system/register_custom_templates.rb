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
        return broadcast(:invalid, form.errors.full_messages.join(". ")) if form.invalid?

        @organization = create_organization
        CreateTemplateFields.call(@organization, form.template) do
          on(:error) do |message|
            @organization.destroy!
            raise StandardError, message
          end
        end
        invite_form = invite_user_form(@organization)
        invitation_failed = invite_form.invalid?

        return broadcast(:invalid, "invitation failed") if invitation_failed

        Decidim::InviteUser.call(invite_form) if @organization && invite_form

        broadcast(:ok)
      rescue StandardError => e
        broadcast(:invalid, e.message)
      end

      private

      attr_reader :form

      def create_organization
        Decidim::Organization.create!(
          name: form.name,
          host: form.host,
          logo: create_organization_logo,
          reference_prefix: form.reference_prefix,
          available_locales: form.available_locales,
          default_locale: form.default_locale,
          users_registration_mode: form.users_registration_mode,
          force_users_to_authenticate_before_access_organization: form.fields("force_users_to_authenticate_before_access_organization"),
          colors: form.fields("colors"),
          external_domain_whitelist: form.fields("external_domain_whitelist"),
          available_authorizations: form.fields("available_authorizations"),
          cta_button_path: form.fields("cta_button_path"),
          time_zone: form.fields("time_zone"),
          rich_text_editor_in_public_views: form.fields("rich_text_editor_in_public_views")
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

      def create_organization_logo
        logo_data = form.fields("logo")

        return unless logo_data

        ActiveStorage::Blob.create_and_upload!(
          io: File.open(File.join(templates_root, logo_data["file"])),
          filename: logo_data["file"],
          content_type: logo_data["content_type"]
        )
      end

      def templates_root
        OrganizationTemplates.template_root
      end
    end
  end
end
