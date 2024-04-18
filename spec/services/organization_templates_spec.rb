# frozen_string_literal: true

require "rails_helper"

describe OrganizationTemplates do
  it "list all organization templates" do
    OrganizationTemplates.template_root = "spec/fixtures/templates"
    expect(OrganizationTemplates.all.pluck("name")).to eq(["Votacions AFFaC", "Husker-aFFaC", "Second"])
    expect(OrganizationTemplates.all.pluck("id")).to eq(["affac-votings", "husker", "two"])
  end
end
