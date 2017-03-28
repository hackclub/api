class FollowUpIfNeededJob < ApplicationJob
  HACK_CLUB_TEAM_ID = 'T0266FRGM'.freeze

  def self.next_ping_interval(min_length, timezone_name)
    tz = ActiveSupport::TimeZone.new(timezone_name)
    return (Time.now + min_length) if tz.nil?

    next_ping_time = tz.now + min_length

    midnight = tz.now.beginning_of_day

    min = midnight + 7.hours
    max = midnight + 19.hours

    next_ping_time = min if (next_ping_time <= min || next_ping_time >= max)

    tz.now - next_ping_time
  end

  def perform(interaction_id, last_state_name, last_message_timestamp,
              follow_up_interval, msgs_to_follow_up_with, timezone_name = '')
    interaction = Hackbot::Interaction.find interaction_id

    return if interaction.nil?
    return if last_state_name != interaction.state
    return if last_message_timestamp != interaction.data['last_message_ts']
    return if msgs_to_follow_up_with.empty?

    send_follow_up(msgs_to_follow_up_with.shift, interaction.data['channel'])

    interval = self.class.next_ping_interval(follow_up_interval, timezone_name)

    FollowUpIfNeededJob
      .set(wait: interval)
      .perform_later(interaction_id, last_state_name, last_message_timestamp,
                     follow_up_interval, msgs_to_follow_up_with)
  end

  def send_follow_up(msg, channel)
    SlackClient.rpc('chat.postMessage',
                    access_token,
                    channel: channel,
                    text: msg,
                    as_user: true)
  end

  def access_token
    slack_team.bot_access_token
  end

  def slack_team
    Hackbot::Team.find_by(team_id: HACK_CLUB_TEAM_ID)
  end
end
