# frozen_string_literal: true

require "spec_helper"

module Decidim
  module System
    class RegisterCustomTemplates
      describe RegisterCustomTemplates do
        describe "call" do
          let(:form) do
            RegisterCustomTemplatesForm.new(params)
          end

          let(:command) { described_class.new(form) }

          context "when the form is invalid" do
            let(:params) do
              {
                name: nil
              }
            end

            it "returns an invalid response" do
              expect { command.call }.to broadcast(:invalid)
            end
          end
        end
      end
    end
  end
end
