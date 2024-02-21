# frozen_string_literal: true

class OrganizationTemplates
  def self.all
    @all || Dir.glob(Rails.root.join(Rails.application.secrets.affac[:templates_folder], "*.yml")).map do |file|
      content = YAML.load_file(file)
      { "name" => content["name"], "id" => content["id"] }
    end
  end
end
