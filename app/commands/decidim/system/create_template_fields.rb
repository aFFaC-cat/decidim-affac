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
      create_scopes!
      create_consultations!
    end

    private

    def create_scopes!
      return unless template.fields && template.fields["scopes"]

      template.fields["scopes"].each do |scope|
        Decidim::Scope.create!(
          organization: organization,
          name: scope["name"].to_h {|lang, val| [lang, interpolate(val)] },
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
          title: participatory_space["title"].to_h {|lang, val| [lang, interpolate(val)] },
          description: participatory_space["description"].to_h {|lang, val| [lang, interpolate(val)] },
          subtitle: participatory_space["subtitle"].to_h {|lang, val| [lang, interpolate(val)] },
          highlighted_scope: Decidim::Scope.find_by(code: participatory_space["highlighted_scope"]),
          start_voting_date: Time.current + 1.month,
          end_voting_date: Time.current + 2.months,
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

    def templates_root
      OrganizationTemplates.template_root
    end

    attr_reader :organization, :template
  end
end
