# frozen_string_literal: true

module Decidim::System
  # A command with all the business logic to create the default content blocks
  # for a newly-created organization.
  class CreateTemplateFields < Decidim::Command
    DEFAULT_CONTENT_BLOCKS = [:hero, :footer_sub_hero, :highlighted_content_banner, :highlighted_consultations, :upcoming_meetings].freeze

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
      create_participatory_spaces!
    end

    private

    def create_participatory_spaces!
      return unless template.fields && template.fields["participatory_spaces"]

      template.fields["participatory_spaces"].each do |participatory_space|
        manifest = Decidim.find_resource_manifest(participatory_space["manifest"])
        next unless manifest

        klass = manifest.model_class_name.constantize

        klass.create!(
          organization: organization,
          name: interpolate((participatory_space["name"]).to_s),
          published_at: Time.now.utc
        )
        next unless participatory_space["images_container"]

        participatory_space["images_container"].each do |container|
          blob = ActiveStorage::Blob.create_and_upload!(
            io: File.open(File.join(templates_root, participatory_space[container]["file"])),
            filename: participatory_space[container]["file"],
            content_type: participatory_space[container]["content_type"],
            metadata: nil
          )
          klass.images_container.send("#{container["name"]}=", blob)
        end
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
              io: File.open(File.join(templates_root, content_block[container]["file"])),
              filename: content_block[container]["file"],
              content_type: content_block[container]["content_type"],
              metadata: nil
            )
            block.images_container.send("#{container["name"]}=", blob)
          end
        end
        block.settings = content_block["settings"] if content_block["settings"]
        block.save!
      end
    end

    def interpolate(string)
      string.replace("%{year}", Time.current.year)
      string.replace("%{organization_name}", organization.name)
    end

    def templates_root
      OrganizationTemplates.templates_root
    end

    attr_reader :organization, :template
  end
end
