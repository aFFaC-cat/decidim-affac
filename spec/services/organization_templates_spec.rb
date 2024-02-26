# frozen_string_literal: true

require "rails_helper"

describe OrganizationTemplates do
  it "list all organization templates" do
    OrganizationTemplates.template_root = "spec/fixtures/templates"
    expect(OrganizationTemplates.all).to eq([
                                              { "name" => "Votacions AFFaC", "id" => "affac-votings" },
                                              { "name" => "Husker-aFFaC", "id" => "husker" },
                                              { "name" => "Second", "id" => "two" }
                                            ])
  end
end
