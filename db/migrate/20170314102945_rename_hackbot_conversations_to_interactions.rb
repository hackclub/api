class RenameHackbotConversationsToInteractions < ActiveRecord::Migration[5.0]
  def change
    rename_table :hackbot_conversations, :hackbot_interactions

    reversible do |change|
      change.up do
        execute <<-SQL
UPDATE hackbot_interactions
  SET type = replace(type, 'Hackbot::Conversations', 'Hackbot::Interactions')
SQL
      end

      change.down do
        execute <<-SQL
UPDATE hackbot_interactions
  SET type = replace(type, 'Hackbot::Interactions', 'Hackbot::Conversations')
SQL
      end
    end
  end
end
