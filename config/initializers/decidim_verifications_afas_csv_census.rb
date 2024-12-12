# frozen_string_literal: true

Decidim::AfaCsvCensus.configure do |config|
  config.col_sep = ";"
  config.fields = {
    # DNI sòcia
    dni: {
      column: "dni_document",
      type: String,
      search: true,
      encoded: true,
      format: /\A[A-Z0-9]*\z/
    },
    # data de naixement de la persona designada per l'AMPA/AFA per assistir a l'assemblea.
    # format dd/mm/yyyy
    naixement: {
      column: "birth_date",
      type: Date,
      search: true,
      encoded: false,
      format: %r{\d{2}/\d{2}/\d{4}},
      parse: proc { |s| Time.zone.parse(s).to_date if s.present? }
    }
  }
end
