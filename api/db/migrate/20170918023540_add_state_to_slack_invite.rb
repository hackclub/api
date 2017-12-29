# frozen_string_literal: true
class AddStateToSlackInvite < ActiveRecord::Migration[5.0]
  def change
    add_column :slack_invites, :state, :text
  end
end
