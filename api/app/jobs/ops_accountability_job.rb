class OpsAccountabilityJob < ApplicationJob
  PIPELINE_KEY = Rails.application.secrets.streak_club_applications_pipeline_key

  NEEDS_REVIEW_STAGE_KEY = '5001'.freeze
  ACCEPTED_STAGE_KEY = '5016'.freeze

  SLACK_TEAM_ID = Rails.application.secrets.default_slack_team_id
  SLACK_CHANNEL = 'C0C78SG9L'.freeze

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Style/GuardClause
  def perform(channel = SLACK_CHANNEL)
    @channel = channel

    ua = unassigned_applications
    oua = old_unreviewed_applications
    aa = not_scheduled_applications

    notify "There are #{ua.count} unassigned applications." unless ua.empty?

    unless oua.empty?
      notify "There are #{oua.count} applications that have been around for "\
        "like two days... and STILL haven't been reviewed"
    end

    unless aa.empty?
      notify "#{aa.count} clubs have been accepted, but haven't had their "\
        'onboarding calls schedule after a week!'
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Style/GuardClause

  def not_scheduled_applications
    accepted_applications.select do |a|
      been_in_stage_for(a, 7.days.ago)
    end
  end

  def old_unreviewed_applications
    unreviewed_applications.select do |a|
      been_in_stage_for(a, 2.days.ago)
    end
  end

  def unassigned_applications
    unreviewed_applications.select do |a|
      assignees = a[:assigned_to_sharing_entries]

      assignees.find { |user| user[:email] == 'api@hackclub.com' } &&
        assignees.length == 1
    end
  end

  def unreviewed_applications
    applications.select { |a| a[:stage_key] == NEEDS_REVIEW_STAGE_KEY }
  end

  def accepted_applications
    applications.select { |a| a[:stage_key] == ACCEPTED_STAGE_KEY }
  end

  def applications
    @applications ||= StreakClient::Box.all_in_pipeline(PIPELINE_KEY)
  end

  def been_in_stage_for(a, t)
    ts = a[:last_stage_change_timestamp] / 1000
    in_stage_since = DateTime.strptime(ts.to_s, '%s')

    t > in_stage_since
  end

  def notify(msg)
    team = Hackbot::Team.find_by(team_id: SLACK_TEAM_ID)

    throw 'Fuck this' unless team

    SlackClient::Chat.send_msg(
      @channel,
      msg,
      team.bot_access_token,
      as_user: true
    )
  end
end
