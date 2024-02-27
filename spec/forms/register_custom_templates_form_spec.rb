# frozen_string_literal: true

require "rails_helper"

module Decidim::System
  describe RegisterCustomTemplatesForm do
    context "with valid attributes" do
      let(:name) { Decidim::Faker::Localized.name }
      let(:host) { Decidim::Faker::Localized.word }
      let(:reference_prefix) { Decidim::Faker::Localized.word }
      let(:organization_admin_email) { Faker::Internet.email }
      let(:organization_admin_name) { Decidim::Faker::Localized.name }

      it { is_expected.to be_valid }
    end

    context "with missing attributes" do
      shared_examples "invalid form" do
        it { is_expected.to be_invalid }
      end

      context "when name is missing" do
        let(:name) { {} }

        it_behaves_like "invalid form"
      end

      context "when host is missing" do
        let(:host) { {} }

        it_behaves_like "invalid form"
      end

      context "when organization admin email is missing" do
        let(:organization_admin_email) { {} }

        it_behaves_like "invalid form"
      end

      context "when organization admin name is missing" do
        let(:organization_admin_name) { {} }

        it_behaves_like "invalid form"
      end
    end

    describe "#default_locale" do
      context "when template has a default_locale" do
        let(:template) { instance_double(OrganizationTemplates, fields: { "organization" => { "default_locale" => "es" } }) }

        before { allow(subject).to receive(:template).and_return(template) }

        it "returns the default_locale from the template" do
          expect(subject.default_locale).to eq("es")
        end
      end

      context "when template does not have a default_locale" do
        let(:template) { instance_double(OrganizationTemplates, fields: {}) }

        before { allow(subject).to receive(:template).and_return(template) }

        it "returns the default_locale from Decidim" do
          allow(Decidim).to receive(:default_locale).and_return("en")
          expect(subject.default_locale).to eq("en")
        end
      end
    end
  end
end
