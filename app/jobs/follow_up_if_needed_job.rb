class FollowUpIfNeededJob < ApplicationJob
  HACK_CLUB_TEAM_ID = 'T0266FRGM'.freeze

  def self.next_ping_interval(min_length, timezone_name)
    tz = ActiveSupport::TimeZone.new(timezone_name) || Time.zone

    next_ping_time = next_acceptable_hour(tz, tz.now + min_length)

    tz.now - next_ping_time
  end

  def self.next_acceptable_hour(timezone, time)
    midnight = timezone.now.beginning_of_day

    min = midnight + 7.hours
    max = midnight + 19.hours

    if time <= min
      min
    elsif time >= max
      min.tomorrow
    else
      time
    end
  end

  # rubocop:disable Metrics/AbcSize
  def perform(interaction_id, last_state_name, last_message_timestamp,
              follow_up_interval, msgs_to_follow_up_with, tz_name = '')
    interaction = Hackbot::Interaction.find interaction_id

    return if interaction.nil?
    return if last_state_name != interaction.state
    return if last_message_timestamp != interaction.data['last_message_ts']
    return if msgs_to_follow_up_with.empty?

    send_follow_up(msgs_to_follow_up_with.shift, interaction.data['channel'])

    FollowUpIfNeededJob
      .set(wait: self.class.next_ping_interval(follow_up_interval, tz_name))
      .perform_later(interaction_id, last_state_name, last_message_timestamp,
                     follow_up_interval, msgs_to_follow_up_with)
  end
  # rubocop:enable Metrics/AbcSize

  def send_follow_up(msg, channel)
    SlackClient::Chat.send_msg(channel, msg, access_token, as_user: true)
  end

  def access_token
    slack_team.bot_access_token
  end

  def slack_team
    Hackbot::Team.find_by(team_id: HACK_CLUB_TEAM_ID)
  end
end
