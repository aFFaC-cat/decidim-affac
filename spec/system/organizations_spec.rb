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
      expect(page).to have_content("Consultation for aFFas")
      expect(page).to have_content("New from template")
    end

    it "shows templates available to create an organization" do
      select "Second", from: "customTemplateSelect"
      click_link "New from template"

      expect(page).to have_content("Organization form")

      fill_in "Name", with: "Citizen Corp"
      fill_in "Host", with: "www.example.org"
      fill_in "Organization admin name", with: "City Mayor"
      fill_in "Organization admin email", with: "mayor@example.org"
      click_button "Create Organization"

      expect(page).to have_css("div.flash.alert")
    end
  end
end
