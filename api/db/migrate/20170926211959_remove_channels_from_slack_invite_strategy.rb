class RemoveChannelsFromSlackInviteStrategy < ActiveRecord::Migration[5.0]
  def change
    remove_column :slack_invite_strategies, :channels
  end
end
