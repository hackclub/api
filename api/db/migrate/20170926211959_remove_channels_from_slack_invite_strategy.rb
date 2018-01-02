# frozen_string_literal: true

# Disabling this Rubocop check because it was implemented after this migration
# was written.
#
# rubocop:disable Rails/ReversibleMigration
class RemoveChannelsFromSlackInviteStrategy < ActiveRecord::Migration[5.0]
  def change
    remove_column :slack_invite_strategies, :channels
  end
end
# rubocop:enable Rails/ReversibleMigration
