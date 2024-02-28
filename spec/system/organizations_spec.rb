# frozen_string_literal: true

require "rails_helper"

describe "Organizations", type: :system do
  let(:admin) { create :admin }

  context "when an admin authenticated" do
    before do
      login_as admin, scope: :admin
      visit decidim_system.root_path
      click_on "Organizations"
    end

    it "shows the template selector" do
      expect(page).to have_content("Votacions AFFaC")
      expect(page).to have_content("New from template")
    end

    it "selects a template and creates an organization" do
      select "Second", from: "customTemplateSelect"
      find("#templateLink").click

      expect(current_url).to include("/new?template_id=two")
      expect(page).to have_content("Organization form")

      fill_in "Name", with: "Citizen Corp"
      fill_in "Reference prefix", with: "CCORP"
      fill_in "Host", with: "www.example.org"
      fill_in "Organization admin name", with: "City Mayor"
      fill_in "Organization admin email", with: "mayor@example.org"
      click_button "Create Organization"

      expect(page).to have_css("div.flash.success")
    end

    context "when a real template" do
      before do
        OrganizationTemplates.template_root = "lib/templates"
        visit decidim_system.organizations_path
      end

      it "creates and organization from a template" do
        select "Votacions AFFaC", from: "customTemplateSelect"
        find("#templateLink").click

        expect(current_url).to include("/new?template_id=affac-votings")
        expect(page).to have_content("Organization form")

        fill_in "Name", with: "Citizen Corp"
        fill_in "Reference prefix", with: "CCORP"
        fill_in "Host", with: "www.example.org"
        fill_in "Organization admin name", with: "City Mayor"
        fill_in "Organization admin email", with: "mayor@example.org"
        click_button "Create Organization"

        blocks = Decidim::ContentBlock
        expect(blocks.count).to eq(5)
        block_hero = blocks.find_by(manifest_name: :hero)
        expect(block_hero.settings.welcome_text).to eq({ "ca" => "Hola!", "es" => "Hola!" })
        block_highlighted_consultations = blocks.find_by(manifest_name: :highlighted_consultations)
        expect(block_highlighted_consultations.settings.max_results).to eq(4)
        first_organization = Decidim::Organization.first
        expect(first_organization.first.default_locale).to eq("ca")
        expect(first_organization.first.users_registration_mode).to eq("enabled")
        expect(first_organization.first.available_locales).to eq(%w(ca es))
        expect(first_organization.first.force_users_to_authenticate_before_access_organization).to be(false)
        consultations = Decidim::Consultation.first
        # check consultation
      end
    end
  end
end
