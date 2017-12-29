# frozen_string_literal: true
class AddFieldsForCustomSlackInvite < ActiveRecord::Migration[5.0]
  def change
    add_column :slack_invites, :slack_invite_id, :text
    add_column :slack_invites, :full_name, :text
    add_column :slack_invites, :username, :text
    add_column :slack_invites, :password, :text
  end
end
