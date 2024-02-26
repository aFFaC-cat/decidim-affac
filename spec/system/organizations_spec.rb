# frozen_string_literal: true

require "rails_helper"

describe "Organizations", type: :system do
  let(:admin) { create :admin }

  context "when an admin authenticated" do
    before do
      login_as admin, scope: :admin
      visit decidim_system.root_path
      click_link "Organizations"
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

        expect(Decidim::ContentBlock.last.settings).eq({"ca" => "Hola!", "es" => "Hola!"})
      end
    end
  end
end
