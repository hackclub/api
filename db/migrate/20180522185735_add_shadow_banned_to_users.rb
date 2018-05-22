# frozen_string_literal: true

class AddShadowBannedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :shadow_banned_at, :datetime
  end
end
