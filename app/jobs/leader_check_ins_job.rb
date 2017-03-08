# Start check-ins with every active club leader through Hackbot.
class LeaderCheckInsJob < ApplicationJob
  queue_as :default

  HACK_CLUB_TEAM_ID = 'T0266FRGM'.freeze
  CLUB_ACTIVE_STAGE_KEY = '5003'.freeze
  CLUB_PIPELINE_KEY = Rails.application.secrets.streak_club_pipeline_key
  LEADER_ACTIVE_STAGE_KEY = '5006'.freeze
  LEADER_PIPELINE_KEY = Rails.application.secrets.streak_leader_pipeline_key

  def perform(streak_keys = [])
    user_ids = if streak_keys.empty?
                 point_of_contacts
               else
                 user_ids_from_streak_keys streak_keys
               end

    # We're looping through twice to validate that all users are message-able
    # before triggering the first conversation.
    user_ims = user_ids.map do |id|
      im = open_im id
      raise Exception.new("Slack user ID not found: '#{id}'") unless im[:ok]
      im
    end

    user_ids.zip(user_ims).each do |id, im|
      event = construct_fake_event(id, im[:channel][:id])

      start_check_in event
    end
  end

  private

  def start_check_in(event)
    convo = Hackbot::Conversations::CheckIn.create(team: slack_team)
    convo.handle event
    convo.save!
  end

  # This constructs a fake Slack event to start the conversation with. It'll be
  # sent to the conversation's start method.
  #
  # This is clearly a hack and our conversation class should be refactored to
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

  def open_im(user_id)
    SlackClient::Chat.open_im(user_id, access_token)
  end

  def user_ids_from_streak_keys(streak_keys)
    active_leader_boxes
      .select { |box| streak_keys.include? box[:key] }
      .map { |box| Leader.find_by(streak_key: box[:key]) }
      .map(&:slack_id)
  end

  def clubs_from_streak_boxes(streak_boxes)
    active_club_boxes.map { |box| Club.find_by(streak_key: box[:key]) }
  end

  def point_of_contacts
    clubs = clubs_from_streak_boxes active_club_boxes

    clubs
      .select { |clb| !clb[:point_of_contact_id].nil? }
      .map(&:point_of_contact)
      .select { |ldr| active? ldr }
      .select { |ldr| ldr.slack_id.present? }
      .map(&:slack_id)
  end

  def active?(leader)
    leader_box = active_leader_boxes.find do |box|
      box[:key].eql? leader.streak_key
    end

    !leader_box.nil?
  end

  def active_club_boxes
    @club_active_boxes ||= StreakClient::Box
                    .all_in_pipeline(CLUB_PIPELINE_KEY)
                    .select { |b| b[:stage_key] == CLUB_ACTIVE_STAGE_KEY }

    @club_active_boxes
  end

  def active_leader_boxes
    @leader_active_boxes ||= StreakClient::Box
                      .all_in_pipeline(LEADER_PIPELINE_KEY)
                      .select { |b| b[:stage_key] == LEADER_ACTIVE_STAGE_KEY }

    @leader_active_boxes
  end

  def access_token
    slack_team.bot_access_token
  end

  def slack_team
    Hackbot::Team.find_by(team_id: HACK_CLUB_TEAM_ID)
  end
end
