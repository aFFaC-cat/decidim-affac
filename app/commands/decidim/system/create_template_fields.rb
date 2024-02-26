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
      content_blocks.each_with_index do |manifest, index|
        weight = (index + 1) * 10
        Decidim::ContentBlock.create(
          decidim_organization_id: organization.id,
          weight: weight,
          scope_name: :homepage,
          manifest_name: manifest.name,
          published_at: Time.current
        )
      end
    end

    private

    def content_blocks
      Decidim.content_blocks.for(:homepage).select(&:default)
    end

    attr_reader :organization, :template
  end
end
