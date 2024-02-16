# frozen_string_literal: true

module Decidim
  module System
    class CustomTemplatesController < Decidim::System::ApplicationController
      before_action :ensure_template_exists, only: [:new]
      helper_method :template

      def new
        @form = form(RegisterCustomTemplatesForm).instance
      end

      def create
        @form = form(RegisterCustomTemplatesForm).from_params(params)

        RegisterCustomTemplates.call(@form) do
          on(:invalid) do
            flash.now[:alert] = I18n.t("decidim.system.custom_templates.invalid_message")
            render :new
          end
        end
      end

      private

      def template
        params[:template]
      end

      def ensure_template_exists
        return if template.present?

        flash.alert = I18n.t("decidim.system.custom_templates.no_template")
        redirect_to decidim_system.root_path
      end
    end
  end
end
