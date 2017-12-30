# frozen_string_literal: true
class AddThemeToSlackInviteStrategy < ActiveRecord::Migration[5.0]
  def change
    add_column :slack_invite_strategies, :theme, :text
  end
end
