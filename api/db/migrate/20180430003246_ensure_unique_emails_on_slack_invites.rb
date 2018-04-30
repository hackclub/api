# frozen_string_literal: true

class EnsureUniqueEmailsOnSlackInvites < ActiveRecord::Migration[5.2]
  def change
    add_index :slack_invites, :email, unique: true
  end
end
