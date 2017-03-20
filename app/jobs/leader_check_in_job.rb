# Start check-ins with a single active point of contact through Hackbot.
class LeaderCheckInJob < ApplicationJob
  queue_as :default

  SLACK_TEAM_ID = 'T0266FRGM'.freeze

  def perform(streak_key)
    id = slack_id_from_streak_key streak_key
    im = open_im id
    unless im[:ok]
      raise(Exception, "Not able to open instant message: '#{im[:error]}'")
    end

    start_check_in
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

  def start_check_in
    Hackbot::Interactions::CheckIn.trigger(leader.slack_id)
  end

  # This constructs a fake Slack event to start the interaction with. It'll be
  # sent to the interaction's start method.
  #
  # This is clearly a hack and our interaction class should be refactored to
  # account for this use case.
  def construct_fake_event(user_id, channel_id)
    {
      team_id: slack_team.team_id,
      user: user_id,
      type: 'message',
      channel: channel_id,
      ts: 'fake.timestamp'
    }
  end

  def leader
    Leader.find_by(streak_key: streak_key)
  end

  def open_im(user_id)
    SlackClient::Chat.open_im(user_id, access_token)
  end

  def access_token
    slack_team.bot_access_token
  end

  def slack_team
    Hackbot::Team.find_by(team_id: SLACK_TEAM_ID)
  end
end
