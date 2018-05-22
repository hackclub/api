class AddLeadershipPositionToLeadershipPositionInvites < ActiveRecord::Migration[5.2]
  def change
    add_reference :leadership_position_invites, :leadership_position, foreign_key: true
  end
end
