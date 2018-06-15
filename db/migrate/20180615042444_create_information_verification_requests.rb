# frozen_string_literal: true

class CreateInformationVerificationRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :new_clubs_information_verification_requests do |t|
      t.references :new_club, foreign_key: true, index: {
        name: 'index_information_verification_requests_new_club_id'
      }
      t.datetime :verified_at
      t.references :verifier, foreign_key: { to_table: :users }, index: {
        name: 'index_information_verification_requests_verifier_id'
      }

      t.timestamps
    end
  end
end
