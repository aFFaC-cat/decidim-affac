# frozen_string_literal: true

module Decidim
  module System
    class CustomTemplatesController < Decidim::System::ApplicationController
      # before_action :ensure_template_exists

      def new; end

      # private

      # def ensure_template_exists
      #   abort("no template")
      # end
    end
  end
end
