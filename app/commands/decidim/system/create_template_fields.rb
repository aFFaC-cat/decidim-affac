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
      create_content_blocks!
      create_scopes!
      create_consultations!
      create_default_pages!
      broadcast(:ok)
    rescue StandardError => e
      broadcast(:invalid, e.message)
    end

    private

    def create_scopes!
      return unless template.fields && template.fields["scopes"]

      template.fields["scopes"].each do |scope|
        Decidim::Scope.create!(
          organization: organization,
          name: scope["name"].transform_values { |val| interpolate(val) },
          code: scope["code"]
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
          introductory_video_url: participatory_space["introductory_video_url"],
          highlighted_scope: Decidim::Scope.find_by(code: participatory_space["highlighted_scope"]),
          start_voting_date: 1.month.from_now,
          end_voting_date: 2.months.from_now,
          published_at: Time.now.utc
        }
        if participatory_space["banner_image"]
          params[:banner_image] = ActiveStorage::Blob.create_and_upload!(
            io: File.open(File.join(templates_root, participatory_space["banner_image"]["file"])),
            filename: participatory_space["banner_image"]["file"],
            content_type: participatory_space["banner_image"]["content_type"],
            metadata: nil
          )
        end
        klass.create!(params)
      end
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

    def create_default_pages!
      template.fields["page_topics"].each do |page_topic|
        topic = Decidim::StaticPageTopic.create!(
          title: page_topic["title"],
          description: page_topic["description"].transform_values { |val| interpolate(val) },
          organization: organization,
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
