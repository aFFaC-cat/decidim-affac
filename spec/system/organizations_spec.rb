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
      click_on "New from template"

      expect(current_url).to include("/new?template_id=two")
      expect(page).to have_content("You will create a new organization using Second")

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
        click_on "New from template"

        expect(current_url).to include("/new?template_id=affac-votings")
        expect(page).to have_content("You will create a new organization using Votacions AFFaC")

        fill_in "Name", with: "Citizen Corp"
        fill_in "Reference prefix", with: "CCORP"
        fill_in "Host", with: "whatever.lvh.me"
        fill_in "Organization admin name", with: "City Mayor"
        fill_in "Organization admin email", with: "mayor@example.org"
        click_button "Create Organization"

        blocks = Decidim::ContentBlock
        expect(blocks.count).to eq(5)
        block_hero = blocks.find_by(manifest_name: :hero)
        expect(block_hero.settings.welcome_text).to eq({ "ca" => "Participa Citizen Corp", "es" => "Participa Citizen Corp" })
        expect(block_hero.images_container.background_image.attached?).to be true
        expect(block_hero.images_container.attached_uploader(:background_image).path).not_to be_nil
        block_highlighted_consultations = blocks.find_by(manifest_name: :highlighted_consultations)
        expect(block_highlighted_consultations.settings.max_results).to eq(4)
        organization = Decidim::Organization.first
        expect(organization.default_locale).to eq("ca")
        expect(organization.users_registration_mode).to eq("enabled")
        expect(organization.available_locales).to eq(%w(ca))
        expect(organization.force_users_to_authenticate_before_access_organization).to be(false)
        consultations = Decidim::Consultation.first
        expect(consultations.slug).to eq("consulta-2024")
        expect(consultations.title).to eq({ "ca" => "Consulta per Citizen Corp", "es" => "Consulta para Citizen Corp" })
        expect(consultations.subtitle).to eq({ "ca" => "Et donem la benvinguda a la teva primera consulta!", "es" => "Te damos la bienvenida a tu primera consulta!" })
        description_ca = consultations.description["ca"]
        description_es = consultations.description["es"]
        description_ca_stripped = strip_tags(description_ca)
        description_es_stripped = strip_tags(description_es)
        expect(description_ca_stripped).to include("Et donem la benvinguda a la teva primera consulta!")
        expect(description_es_stripped).to include("Te damos la bienvenida a tu primera consulta!")
        expect(consultations.banner_image.attached?).to be true
        expect(consultations.banner_image).to be_attached

        switch_to_host(organization.host)
        visit decidim.root_path
        expect(page).to have_css(".logo-wrapper")
        expect(page).to have_css(".afa-logo")

        click_link "Més informació"

        expect(page).to have_content("Informació General")
        expect(page).to have_content("Ajuda general")
        expect(page).to have_content("Termes i condicions d'ús")

        click_link "Què són les consultes?"
        expect(page).to have_content("Una consulta és un espai que permet fer una o més preguntes de forma clara a totes les persones que formen part de l’organització")

        click_link "Com puc votar en una consulta?"
        expect(page).to have_content("Per poder votar en les preguntes que formen part d’una consulta, primer cal registrar-se a l’aplicació")

        click_link "Què més puc fer si em registro?"
        expect(page).to have_content("Tot i que no cal registrar-se per accedir al contingut del Participa, registrar-se obre un món de possibilitats")
      end

      it "creates questions and responses from a template" do
        select "Votacions AFFaC", from: "customTemplateSelect"
        click_on "New from template"

        fill_in "Name", with: "Citizen Corp"
        fill_in "Reference prefix", with: "CCORP"
        fill_in "Host", with: "whatever.lvh.me"
        fill_in "Organization admin name", with: "City Mayor"
        fill_in "Organization admin email", with: "mayor@example.org"
        click_button "Create Organization"

        organization = Decidim::Organization.first
        switch_to_host(organization.host)
        visit decidim.root_path
        click_link "Consultes"
        click_link("Consulta per Citizen Corp", match: :first)

        expect(page).to have_content("Et donem la benvinguda a la teva primera consulta!")
        expect(page).to have_content("PREGUNTES PER A AQUESTA CONSULTA")
        expect(page).to have_content("RENDICIÓ DE COMPTES")
        question = Decidim::Consultations::Question.first
        expect(question.slug).to eq("pregunta1")
        expect(question.title).to eq({ "ca" => "Aprovació, si s'escau, de XXX (exemple)", "es" => "Aprovación, en su caso, de XXX (ejemplo)" })
        expect(question.subtitle).to eq({ "ca" => "Sí / No / En Blanc", "es" => "Sí / No / En Blanco" })
        expect(question.what_is_decided).to eq({ "ca" => "Aprovació, si escau, de XXX. Podeu consultar el document en aquest enllaç (exemple)", "es" => "Aprobación, en su caso, de XXX. Puede consultar el documento en este enlace (ejemplo)" })
        expect(question.question_context).to eq({ "ca" => "Aquesta és la una de les preguntes de la consulta. Actualitza'n tots els camps per adaptar-la a les teves necessitats!", "es" => "Ésta es lo una de las preguntas de la consulta. ¡Actualiza todos los campos para adaptarla a tus necesidades!" })
        new_response = Decidim::Consultations::Response.first
        expect(new_response.title).to eq({ "ca" => "Sí", "es" => "Sí" })

        click_link "Participar"
        expect(page).to have_content("Consulta per Citizen Corp")
        expect(page).to have_content("LA PREGUNTA")
        expect(page).to have_content("DEIXA EL TEU COMENTARI")
        expect(page).to have_content("Votació")

        click_link "Ajuda general"
        expect(page).to have_content("Què són les consultes?")
        expect(page).to have_content("Com puc votar en una consulta?")
        expect(page).to have_content("Què més puc fer si em registro?")

        organization = Decidim::Organization.last
        user = create(:user, :admin, :confirmed, :admin_terms_accepted, organization: organization)
        login_as user, scope: :user
        visit decidim_admin.root_path

        expect(page).to have_content("Consultes")
        expect(page).not_to have_content("Assemblees")
        expect(page).not_to have_content("Processos")
        click_on "Configuració"
        expect(page).to have_content("Configuració")
        expect(page).to have_content("Aparença")
        expect(page).to have_content("Pàgina d'inici")
        expect(page).to have_content("Opcions de consulta")
        expect(page).to have_content("Dominis externs permesos")
        expect(page).not_to have_content("Tipus d'àmbit")
        expect(page).not_to have_content("Àrees")
        expect(page).not_to have_content("Tipus d'àrees")
        expect(page).not_to have_content("Seccions d'ajuda")
      end
    end
  end
end
