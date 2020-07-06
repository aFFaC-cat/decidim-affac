# frozen_string_literal: true

Decidim::Verifications::CustomCsvCensus.configure do |config|
  config.fields = {
    # NIF de l'afa/ampa
    nif_afa: {
      type: String,
      search: true,
      format: /\A[A-Z0-9]*\z/
    },
    # N. de sòcia
    membership_number: {
      type: String,
      search: true,
      # format: /\A[A-Z0-9]*\z/
    },
    # DNI
    nif_document: {
      type: String,
      search: true,
      format: /\A[A-Z0-9]*\z/
    },
    # data de naixement de la persona designada per l'AMPA/AFA per assistir a l'assemblea.
    # format dd/mm/yyyy
    birth_date: {
      type: Date,
      search: true,
      format: %r{\d{2}\/\d{2}\/\d{4}},
      parse: proc { |s| s.to_date }
    }
  }
end
