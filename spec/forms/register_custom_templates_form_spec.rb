# frozen_string_literal: true

require "rails_helper"

module Decidim::System
  describe RegisterCustomTemplatesForm do
    let(:name) { Decidim::Faker::Localized.word }
    let(:host) { Decidim::Faker::Localized.word }
    let(:organization_admin_email) { Decidim::Faker::Localized.email }
    let(:organization_admin_name) { Decidim::Faker::Localized.word }

    context "when name is missing" do
      let(:name) { {} }

      it { is_expected.to be_invalid }
    end

    context "when host is missing" do
      let(:host) { {} }

      it { is_expected.to be_invalid }
    end

    context "when organization admin email is missing" do
      let(:organization_admin_email) { {} }

      it { is_expected.to be_invalid }
    end

    context "when organization admin name is missing" do
      let(:organization_admin_name) { {} }

      it { is_expected.to be_invalid }
    end
  end
end
