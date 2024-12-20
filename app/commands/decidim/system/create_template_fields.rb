# frozen_string_literal: true

module Decidim::System
  # A command with all the business logic to create the default content blocks
  # for a newly-created organization.
  class CreateTemplateFields < Decidim::Command
    # Public: Initializes the command.
    #
    # form - A form object with the params.
    def initialize(organization, template)
      @organization = organization
      @template = template
    end

    # Executes the command.
    #
    # Returns nothing.
    def call
      transaction do
        create_default_pages!
        create_content_blocks!
        create_scopes!
        create_consultations!
        create_awesome_configs!
        broadcast(:ok)
      end
    rescue StandardError => e
      broadcast(:error, e.message)
    end

    private

    def create_scopes!
      return unless template.fields && template.fields["scopes"]

      template.fields["scopes"].each do |scope|
        main_scope = Decidim::Scope.create!(
          organization: organization,
          name: scope["name"].transform_values { |val| interpolate(val) },
          code: scope["code"]
        )

        create_sub_scopes(main_scope, scope["sub_scopes"])
      end
    end

    def create_sub_scopes(parent_scope, sub_scopes)
      return unless sub_scopes

      sub_scopes.each do |sub_scope|
        Decidim::Scope.create!(
          organization: parent_scope.organization,
          name: sub_scope["name"].transform_values { |val| interpolate(val) },
          code: sub_scope["code"],
          parent_id: parent_scope.id
        )
      end
    end

    def create_consultations!
      return unless template.fields && template.fields["consultations"]

      template.fields["consultations"].each do |participatory_space|
        manifest = Decidim.find_resource_manifest(participatory_space["manifest"])
        next unless manifest

        klass = manifest.model_class_name.constantize

        params = {
          organization: organization,
          slug: interpolate(participatory_space["slug"]),
          title: participatory_space["title"].transform_values { |val| interpolate(val) },
          description: participatory_space["description"].transform_values { |val| interpolate(val) },
          subtitle: participatory_space["subtitle"].transform_values { |val| interpolate(val) },
          highlighted_scope: Decidim::Scope.find_by(code: participatory_space["highlighted_scope"], organization: organization),
          start_voting_date: 1.month.from_now,
          end_voting_date: 2.months.from_now,
          published_at: Time.now.utc,
          banner_image: create_banner_image(participatory_space["banner_image"])
        }

        consultation = klass.create!(params)

        create_questions(consultation, participatory_space["questions"])
      end
    end

    def create_banner_image(banner_image)
      return unless banner_image

      ActiveStorage::Blob.create_and_upload!(
        io: File.open(File.join(templates_root, banner_image["file"])),
        filename: banner_image["file"],
        content_type: banner_image["content_type"],
        metadata: nil
      )
    end

    def create_questions(consultation, questions)
      return unless questions

      questions.each do |question|
        new_question = Decidim::Consultations::Question.create!(
          organization: consultation.organization,
          consultation: consultation,
          title: question["title"].transform_values { |val| interpolate(val) },
          subtitle: question["subtitle"].transform_values { |val| interpolate(val) },
          what_is_decided: question["what_is_decided"].transform_values { |val| interpolate(val) },
          promoter_group: question["promoter_group"].transform_values { |val| interpolate(val) },
          question_context: question["question_context"].transform_values { |val| interpolate(val) },
          participatory_scope: question["participatory_scope"].transform_values { |val| interpolate(val) },
          slug: question["slug"],
          scope: Decidim::Scope.find_by(code: question["scope"], organization: organization),
          published_at: Time.current
        )

        create_resource_permissions(new_question, question["resource_permissions"])
        create_responses(new_question, question["responses"])
      end
    end

    def create_responses(question, responses)
      return unless responses

      responses.each do |response|
        new_response = response["title"].transform_values { |val| interpolate(val) }

        question.responses.create!(title: new_response)
      end
    end

    def create_resource_permissions(resource, permissions)
      return unless permissions

      Decidim::ResourcePermission.create!(
        resource: resource,
        permissions: permissions
      )
    end

    def create_content_blocks!
      return unless template.fields && template.fields["content_blocks"]

      template.fields["content_blocks"].each do |content_block|
        block = Decidim::ContentBlock.create!(
          decidim_organization_id: organization.id,
          weight: content_block["weight"],
          scope_name: content_block["scope_name"],
          manifest_name: content_block["manifest_name"],
          published_at: Time.current
        )
        if content_block["images_container"]
          content_block["images_container"].each do |container|
            blob = ActiveStorage::Blob.create_and_upload!(
              io: File.open(File.join(templates_root, container["file"])),
              filename: container["file"],
              content_type: container["content_type"],
              metadata: nil
            )
            block.images_container.send("#{container["name"]}=", blob)
          end
        end
        block.settings = interpolate_settings(content_block["settings"]) if content_block["settings"]
        block.save!
      end
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def create_default_pages!
      return unless template.fields && template.fields["page_topics"]

      template.fields["page_topics"].each do |page_topic|
        topic = Decidim::StaticPageTopic.create!(
          title: page_topic["title"],
          description: page_topic["description"]&.transform_values { |val| interpolate(val) } || {},
          organization: organization,
          show_in_footer: page_topic["show_in_footer"].present?,
          weight: page_topic["weight"]
        )

        page_topic["pages"].each do |page|
          Decidim::StaticPage.create!(
            slug: page["slug"],
            title: page["title"].transform_values { |val| interpolate(val) },
            content: page["content"].transform_values { |val| interpolate(val) },
            topic: topic,
            organization: organization,
            weight: page["weight"]
          )
        end
      end
    end

    # rubocop:enable Metrics/CyclomaticComplexity
    #
    def create_awesome_configs!
      return unless template.fields && template.fields["awesome_configs"]

      template.fields["awesome_configs"].each do |config|
        Decidim::DecidimAwesome::AwesomeConfig.create!(
          organization: organization,
          var: config["var"],
          value: config["value"]
        )
      end
    end

    def interpolate(str)
      string = str.dup
      string.gsub!("%{year}", Time.current.year.to_s)
      string.gsub!("%{organization_name}", organization.name)
      start_date = Time.current
      string.gsub!("%{start_date}", start_date.strftime("%Y-%m-%d"))
      end_date = start_date + 1.month
      string.gsub!("%{end_date}", end_date.strftime("%Y-%m-%d"))
      string
    end

    def interpolate_settings(settings)
      settings.transform_values do |value|
        case value
        when Hash
          interpolate_settings(value)
        when String
          interpolate(value)
        else
          value
        end
      end
    end

    def templates_root
      OrganizationTemplates.template_root
    end

    attr_reader :organization, :template
  end
end
