# frozen_string_literal: true

class OrganizationTemplates
  def self.all
    @all ||= Dir.glob(Rails.root.join(Rails.application.secrets.affac[:templates_folder], "*.yml")).map do |file|
      YAML.load_file(file)
    end
  end

  attr_reader :template_id

  def initialize(template_id)
    @template_id = template_id
  end

  def fields
    @fields ||= OrganizationTemplates.all.detect { |item| item[:id] == template_id }
  end
end
