# Start check-ins with a single active point of contact through Hackbot.
class LeaderCheckInJob < ApplicationJob
  queue_as :default

  def perform(streak_key)
    slack_id = slack_id_from_streak_key streak_key
    Hackbot::Interactions::CheckIn.trigger(slack_id)
  end

  private

  def slack_id_from_streak_key(streak_key)
    if leader.nil?
      raise(Exception, "Leader with streak key not found: '#{streak_key}'")
    end
    id = leader.slack_id
    if id.blank?
      raise(Exception, "Slack ID not found for leader: '#{streak_key}'")
    end
    id
  end

  def leader
    Leader.find_by(streak_key: streak_key)
  end
end
