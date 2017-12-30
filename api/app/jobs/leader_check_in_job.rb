# frozen_string_literal: true
# Start check-ins with a single active point of contact through Hackbot.
class LeaderCheckInJob < ApplicationJob
  queue_as :default

  def perform(streak_key)
    @streak_key = streak_key

    interaction = Hackbot::Interactions::CheckIn.trigger(slack_id)

    new_data = interaction.data.merge('leader_id' => leader.id,
                                      'club_id' => club.id)
    interaction.update(data: new_data)
  end

  private

  def slack_id
    if leader.nil?
      raise(Exception, "Leader with streak key not found: '#{@streak_key}'")
    end

    id = leader.slack_id
    if id.blank?
      raise(Exception, "Slack ID not found for leader: '#{@streak_key}'")
    end

    id
  end

  def leader
    Leader.find_by(streak_key: @streak_key)
  end

  def club
    leader.clubs.first
  end
end
