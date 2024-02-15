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
      expect(page).to have_content("Choose a template")
      expect(page).to have_content("New from template")
    end
  end
end
