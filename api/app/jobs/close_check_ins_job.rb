# frozen_string_literal: true

class CloseCheckInsJob < ApplicationJob
  queue_as :default

  SLACK_TEAM_ID = 'T0266FRGM'

  def perform(interaction_ids = nil)
    interactions = if interaction_ids
                     check_ins_from_array interaction_ids
                   else
                     unfinished_check_ins
                   end

    interactions.each do |check_in|
      raise(Exception, 'This check in is nil') if check_in.nil?

      close check_in
    end
  end

  # Not allowing when blocks with events is currently broken. Tracked in:
  # https://github.com/bbatsov/rubocop/issues/3696
  #
  # rubocop:disable Lint/EmptyWhen
  def close(check_in)
    case check_in.state
    when 'wait_for_notes'
      check_in.generate_check_in
    when 'wait_for_no_meeting_reason'
      # Leaders in this state should not be marked as 'failed_to_complete'
    else
      check_in.data['failed_to_complete'] = true
      send_close_message check_in.data['channel']
    end

    check_in.state = 'finish'
    check_in.save
  end
  # rubocop:enable Lint/EmptyWhen

  def send_close_message(channel)
    SlackClient::Chat.send_msg(
      channel,
      close_message,
      access_token,
      as_user: true
    )
  end

  def close_message
    CopyService
      .new('jobs/close_check_ins_job', {})
      .get_copy('close')
  end

  def check_ins_from_array(ids)
    ids.map do |id|
      event Hackbot::Interactions::CheckIn.find(id)
    end
  end

  def unfinished_check_ins
    Hackbot::Interactions::CheckIn
      .where.not(state: 'finish')
      .map { |c| event c }
  end

  def event(check_in)
    im = im_info check_in.data['channel']
    if im.nil?
      raise(Exception, 'Not able to open instant message in channel: '\
                       "#{check_in.data['channel']}")
    end

    check_in.event = FakeSlackEventService.new(
      slack_team, im[:user],
      check_in.data['channel']
    ).event

    check_in
  end

  def im_info(channel_id)
    SlackClient::Im.info(channel_id, access_token)
  end

  def access_token
    slack_team.bot_access_token
  end

  def slack_team
    Hackbot::Team.find_by(team_id: SLACK_TEAM_ID)
  end
end
