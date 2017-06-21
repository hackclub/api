class RenameAttendanceConversationTypes < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
UPDATE hackbot_conversations
  SET type = 'Hackbot::Conversations::CheckIn'
  WHERE type = 'Hackbot::Conversations::Attendance'
SQL
  end

  def down
    execute <<-SQL
UPDATE hackbot_conversations
  SET type = 'Hackbot::Conversations::Attendance'
  WHERE type = 'Hackbot::Conversations::CheckIn'
SQL
  end
end
