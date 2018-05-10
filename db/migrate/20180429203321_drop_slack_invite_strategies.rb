# frozen_string_literal: true

class DropSlackInviteStrategies < ActiveRecord::Migration[5.2]
  def change
    remove_reference :slack_invites, :slack_invite_strategy, foreign_key: true
    drop_table :slack_invite_strategies do |t|
      # fields copied and pasted from schema.rb
      t.text 'name'
      t.text 'greeting'
      t.text 'club_name'
      t.text 'primary_color'
      t.text 'user_groups', default: [], array: true
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer 'hackbot_team_id'
      t.text 'theme'
      t.index ['hackbot_team_id'],
              name: 'index_slack_invite_strategies_on_hackbot_team_id'
    end
  end
end
