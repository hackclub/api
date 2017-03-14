class FollowUpIfNeededJob < ApplicationJob
  HACK_CLUB_TEAM_ID = 'T0266FRGM'.freeze

  def perform(interaction_id, last_state_name, last_message_timestamp,
              follow_up_interval, messages_to_follow_up_with)
    interaction = Hackbot::Interaction.find interaction_id

    return if interaction.nil?

    return if last_state_name != interaction.state

    return if last_message_timestamp != interaction.data['last_message_ts']

    return if messages_to_follow_up_with.empty?

    send_follow_up(messages_to_follow_up_with.shift, interaction.data['channel'])

    FollowUpIfNeededJob
      .set(wait: follow_up_interval)
      .perform_later(interaction_id, last_state_name, last_message_timestamp,
                     follow_up_interval, messages_to_follow_up_with)
  end

  private

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
