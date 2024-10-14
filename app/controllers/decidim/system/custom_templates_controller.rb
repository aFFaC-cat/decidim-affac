# frozen_string_literal: true

module Decidim
  module System
    class CustomTemplatesController < Decidim::System::ApplicationController
      before_action :ensure_template_exists, only: [:new]
      helper_method :template_id, :template

      def new
        @form = form(RegisterCustomTemplatesForm).instance
      end

      def create
        @form = form(RegisterCustomTemplatesForm).from_params(params)

        RegisterCustomTemplates.call(@form) do
          on(:ok) do
            flash[:notice] = I18n.t("decidim.system.custom_templates.success_message")
            redirect_to organizations_path
          end

          on(:invalid) do |message|
            flash.now[:alert] = I18n.t("decidim.system.custom_templates.invalid_message", message: message)
            render :new
          end
        end
      end

      private

      def template_id
        params[:template_id]
      end

      def template
        @template ||= OrganizationTemplates.new(template_id)
      end

      def ensure_template_exists
        return if template.exists?

        flash.alert = I18n.t("decidim.system.custom_templates.no_template")
        redirect_to decidim_system.root_path
      end
    end
  end
end
