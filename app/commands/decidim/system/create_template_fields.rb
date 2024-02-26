# frozen_string_literal: true

module Decidim::System
  # A command with all the business logic to create the default content blocks
  # for a newly-created organization.
  class CreateTemplateFields < Decidim::Command
    DEFAULT_CONTENT_BLOCKS = [:hero, :sub_hero, :highlighted_content_banner, :highlighted_consultations, :upcoming_meetings].freeze

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
        if content_block["settings"]
          block.settings = content_block["settings"]
        end
        block.save!
        byebug
      end
    end

    private

    def templates_root
      OrganizationTemplates.templates_root
    end

    attr_reader :organization, :template
  end
end
