# frozen_string_literal: true

class OrganizationTemplates
  def self.template_root
    @template_root ||= Rails.application.secrets.affac[:templates_folder]
  end

  def self.template_root=(value)
    @template_root = value
    @all = nil
  end

  def self.all
    @all ||= Dir.glob(Rails.root.join(template_root, "*.yml")).map do |file|
      YAML.load_file(file)
    end
  end

  attr_reader :template_id

  def initialize(template_id)
    @template_id = template_id
  end

  def fields
    @fields ||= OrganizationTemplates.all.detect { |item| item["id"] == template_id }
  end

  def exists?
    fields.present?
  end
end
