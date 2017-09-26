class AddSlackInviteStrategytoSlackInvite < ActiveRecord::Migration[5.0]
  def change
    add_reference :slack_invites, :slack_invite_strategy, foreign_key: true
  end
end
