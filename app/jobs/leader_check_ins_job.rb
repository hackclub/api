# Start check-ins with every active club leader through Hackbot.
class LeaderCheckInsJob < ApplicationJob
  queue_as :default

  HACK_CLUB_TEAM_ID = 'T0266FRGM'.freeze
  ACTIVE_STAGE_KEY = '5006'.freeze
  LEADER_PIPELINE_KEY = Rails.application.secrets.streak_leader_pipeline_key

  def perform(usernames = [])
    usernames = active_leader_usernames if usernames.empty?

    usernames.each do |username|
      user = user_from_username(username)
      next if user.nil? # couldn't find the user

      im = open_im(user)
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

  def open_im(user)
    SlackClient::Chat.open_im(user[:id], access_token)
  end

  def user_from_username(username)
    @all_users ||= SlackClient::Users.list(access_token)[:members]

    @all_users.find { |u| u[:name] == username }
  end

  def active_leader_usernames
    active_leaders
      .map(&:slack_username)
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
