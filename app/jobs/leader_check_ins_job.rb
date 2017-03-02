# Start check-ins with every active club leader through Hackbot.
class LeaderCheckInsJob < ApplicationJob
  queue_as :default

  HACK_CLUB_TEAM_ID = 'T0266FRGM'.freeze
  ACTIVE_STAGE_KEY = '5006'.freeze
  LEADER_PIPELINE_KEY = Rails.application.secrets.streak_leader_pipeline_key

  def perform(usernames = [])
    user_ids = active_leader_slack_ids

    user_ids = user_ids_from_usernames usernames unless usernames.empty?

    user_ids.each do |user_id|
      im = open_im(user_id)
      event = construct_fake_event(user, im[:channel][:id])

      convo = Hackbot::Conversations::CheckIn.new(team: slack_team)
      convo.handle(event)
      convo.save!
    end
  end

  private

  # This constructs a fake Slack event to start the conversation with. It'll be
  # sent to the conversation's start method.
  #
  # This is clearly a hack and our conversation class should be refactored to
  # account for this use case.
  def construct_fake_event(user, channel_id)
    {
      team_id: slack_team.team_id,
      user: user[:id],
      type: 'message',
      channel: channel_id
    }
  end

  def open_im(user_id)
    SlackClient::Chat.open_im(user_id, access_token)
  end

  def user_ids_from_usernames(usernames)
    usernames.map do |u|
      user = user_from_username u
      next unless user.nil?

      user[:id]
    end
  end

  def user_from_username(username)
    @all_users ||= SlackClient::Users.list(access_token)[:members]

    @all_users.find { |u| u[:name] == username }
  end

  def active_leader_slack_ids
    active_leaders
      .map(&:slack_id)
      .reject { |u| u.nil? || u.empty? }
  end

  def active_leaders
    leader_boxes = StreakClient::Box.all_in_pipeline(LEADER_PIPELINE_KEY)
    active_boxes = leader_boxes.select { |b| b[:stage_key] == ACTIVE_STAGE_KEY }

    active_boxes
      .map { |box| Leader.find_by(streak_key: box[:key]) }
      .reject(&:nil?)
  end

  def access_token
    slack_team.bot_access_token
  end

  def slack_team
    Hackbot::Team.find_by(team_id: HACK_CLUB_TEAM_ID)
  end
end
