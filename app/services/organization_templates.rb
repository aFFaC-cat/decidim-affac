# frozen_string_literal: true

class OrganizationTemplates
  def self.all
    template_files = Dir.glob("lib/templates/*.yml")

    templates = []
    template_files.each do |file|
      content = YAML.load_file(file)
      templates << { "name" => content["name"], "id" => content["id"] }
    end

    templates
  end
end
