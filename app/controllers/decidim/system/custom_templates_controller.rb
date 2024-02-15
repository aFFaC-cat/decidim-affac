# frozen_string_literal: true

module Decidim
  module System
    class CustomTemplatesController < Decidim::System::ApplicationController
      before_action :ensure_template_exists, only: [:new]
      def new; end

      private

      def ensure_template_exists
        return if params[:template].present?

        flash.alert = I18n.t("decidim.system.custom_templates.no_template")
        redirect_to decidim_system.root_path
      end
    end
  end
end
