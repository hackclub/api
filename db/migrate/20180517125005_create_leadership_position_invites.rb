# frozen_string_literal: true

class CreateLeadershipPositionInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :leadership_position_invites do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :new_club, foreign_key: true
      t.references :user, foreign_key: true
      t.datetime :accepted_at
      t.datetime :rejected_at

      t.timestamps
    end
  end
end
