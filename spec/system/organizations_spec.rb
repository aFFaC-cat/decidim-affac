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
      OrganizationTemplates.template_root = "spec/fixtures/templates"
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
      let(:organization) { Decidim::Organization.first }

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
        fill_in "Host", with: "whatever.lvh.me"
        fill_in "Organization admin name", with: "City Mayor"
        fill_in "Organization admin email", with: "mayor@example.org"
        click_button "Create Organization"

        blocks = Decidim::ContentBlock
        expect(blocks.count).to eq(5)
        block_hero = blocks.find_by(manifest_name: :hero)
        expect(block_hero.settings.welcome_text).to eq({ "ca" => "Benvinguda Citizen Corp", "es" => "Bienvenida Citizen Corp" })
        expect(block_hero.images_container.background_image.attached?).to be true
        expect(block_hero.images_container.attached_uploader(:background_image).path).not_to be_nil
        block_highlighted_consultations = blocks.find_by(manifest_name: :highlighted_consultations)
        expect(block_highlighted_consultations.settings.max_results).to eq(4)
        first_organization = Decidim::Organization.first
        expect(first_organization.default_locale).to eq("ca")
        expect(first_organization.users_registration_mode).to eq("enabled")
        expect(first_organization.available_locales).to eq(%w(ca es))
        expect(first_organization.force_users_to_authenticate_before_access_organization).to be(false)
        consultations = Decidim::Consultation.first
        expect(consultations.slug).to eq("consulta-2024")
        expect(consultations.title).to eq({ "ca" => "Consulta per Citizen Corp", "es" => "Consulta para Citizen Corp" })
        expect(consultations.subtitle).to eq({ "ca" => "Et donem la benvinguda a la teva primera consulta!", "es" => "Te damos la bienvenida a tu primera consulta!" })
        expect(consultations.description).to eq({ "ca" => "Et donem la benvinguda a la teva primera consulta!", "es" => "Te damos la bienvenida a tu primera consulta!" })
        expect(consultations.banner_image.attached?).to be true
        expect(consultations.banner_image).to be_attached

        organization = Decidim::Organization.first
        switch_to_host(organization.host)
        visit decidim.root_path
        click_link "Més informació"

        expect(page).to have_content("Informació General")
        expect(page).to have_content("Ajuda general")
        expect(page).to have_content("Termes i condicions d'ús")

        click_link "Què és un procés participatiu?"
        expect(page).to have_content("Un procés participatiu és una seqüència d'activitats participatives")

        click_link "Què són les coordinadores?"
        expect(page).to have_content("Una coordinadora és un grup format per membres d'una organització")

        click_link "Què són les consultes?"
        expect(page).to have_content("Una consulta és un espai que permet realitzar una pregunta")
      end
    end
  end
end
