class CreateSlackInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_invites do |t|
      t.string :email

      t.timestamps
    end
  end
end
