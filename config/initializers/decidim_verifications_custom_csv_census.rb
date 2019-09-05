# frozen_string_literal: true

Decidim::Verifications::CustomCsvCensus.configure do |config|
  config.fields = {
    id_document: {
      type: String,
      search: true,
      format: /\A[A-Z0-9]*\z/
    },
    nif_document: {
      type: String,
      search: true,
      format: /\A[A-Z0-9]*\z/
    }
  }
end
