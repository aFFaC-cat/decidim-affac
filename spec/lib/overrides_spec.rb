# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-forms",
    files: {
      "/app/views/decidim/forms/admin/questionnaires/_question.html.erb" => "70e923b1cc8bd98b63ba4e5819e74476"
    }
  },
  {
    package: "decidim-core",
    files: {
      "/app/views/decidim/devise/registrations/new.html.erb" => "c83d4c7deefdb5859aa7356129502f50",
      "/app/views/decidim/devise/invitations/edit.html.erb" => "e5762f86c0125adc6339400e1796216a",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "5a842f3e880f24f49789ee2f72d96f60"
    }
  },
  {
    package: "decidim-consultations",
    files: {
      "/app/views/decidim/consultations/admin/questions/_form.html.erb" => "1eb11e33f7ffa2739d1c11ff9ab6dff4"
    }
  }
]

describe "Overriden files", type: :view do
  # rubocop:disable Rails/DynamicFindBy
  checksums.each do |item|
    spec = ::Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end
  # rubocop:enable Rails/DynamicFindBy

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
