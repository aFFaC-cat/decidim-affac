# frozen_string_literal: true

class CreateDecidimVerificationsCustomCsvCensusCensusData < ActiveRecord::Migration[5.1]
  def change
    create_table :decidim_verifications_custom_csv_census_census_data do |t|
      t.references :decidim_organization, index: { name: "census_data_org_id_index" }

      # custom fields
      t.string :nif_afa
      t.string :membership_number
      t.string :nif_document
      t.date :birth_date
      t.index [:nif_afa, :membership_number, :nif_document, :birth_date, :decidim_organization_id], unique: true, name: 'index'
      # custom fields

      # The rows in this table are immutable (insert or delete, not update)
      # To explicitly reflect this fact there is no `updated_at` column
      t.datetime "created_at", null: false
    end
  end
end
