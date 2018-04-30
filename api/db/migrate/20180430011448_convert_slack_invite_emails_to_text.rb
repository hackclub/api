# frozen_string_literal: true

class ConvertSlackInviteEmailsToText < ActiveRecord::Migration[5.2]
  def change
    change_column :slack_invites, :email, :text
  end
end
