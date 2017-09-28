class CreateSlackInviteStrategies < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_invite_strategies do |t|
      t.text :name
      t.text :greeting
      t.text :club_name
      t.text :primary_color
      t.text :channels, array: true, default: []
      t.text :user_groups, array: true, default: []

      t.timestamps
    end
  end
end
