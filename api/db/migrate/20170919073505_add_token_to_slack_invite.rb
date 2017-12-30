# frozen_string_literal: true
class AddTokenToSlackInvite < ActiveRecord::Migration[5.0]
  def change
    add_column :slack_invites, :token, :text
  end
end
