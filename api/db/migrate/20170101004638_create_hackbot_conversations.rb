class CreateHackbotConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :hackbot_conversations do |t|
      t.text :type
      t.references :hackbot_team
      t.text :state
      t.json :data

      t.timestamps
    end
  end
end
