# frozen_string_literal: true

require "rails_helper"

module Decidim::System
  describe RegisterCustomTemplates do
    describe "call" do
      before do
        OrganizationTemplates.template_root = "spec/fixtures/templates"
      end

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

      context "when the form is valid" do
        let(:from_label) { "Decide Gotham" }
        let(:params) do
          {
            template_id: "husker",
            name: "Gotham City",
            host: "decide.gotham.gov",
            reference_prefix: "JKR",
            organization_admin_name: "Fiorello Henry La Guardia",
            organization_admin_email: "f.laguardia@gotham.gov"
          }
        end

        it "returns a valid response" do
          expect { command.call }.to broadcast(:ok)
        end

        it "creates a new organization" do
          expect { command.call }.to change(Decidim::Organization, :count).by(1)
          organization = Decidim::Organization.last

          expect(organization.name).to eq("Gotham City")
          expect(organization.host).to eq("decide.gotham.gov")
          expect(organization.reference_prefix).to eq("JKR")
        end

        it "sends a custom email" do
          expect do
            perform_enqueued_jobs { command.call }
          end.to change(emails, :count).by(1)
          expect(last_email_body).to include(URI.encode_www_form(["/admin"]))
        end
      end
    end
  end
end
