class OpsAccountabilityJob < ApplicationJob
  PIPELINE_KEY = Rails.application.secrets.streak_club_applications_pipeline_key

  NEEDS_REVIEW_STAGE_KEY = '5001'.freeze
  ACCEPTED_STAGE_KEY = '5016'.freeze

  SLACK_TEAM_ID = Rails.application.secrets.default_slack_team_id
  SLACK_CHANNEL = 'C0C78SG9L'.freeze

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Style/GuardClause
  def perform(channel = SLACK_CHANNEL)
    @channel = channel

    ua = unassigned_applications
    oua = old_unreviewed_applications
    aa = not_scheduled_applications
    succ = true

    unless ua.empty?
      one_ua = ua.count == 1
      notify "There #{one_ua ? "is" : "are"} #{ua.count} unassigned "\
        "application#{one_ua ? "" : "s"}."
      succ = false
    end

    unless oua.empty?
      one_oua = oua.count == 1
      notify "There #{one_oua ? "is" : "are"} #{oua.count} "\
        "application#{one_oua ? "" : "s"} that #{one_oua ? "has" : "have"} been "\
        "around for like two days... and STILL ha#{one_oua ? "s" : "ve"}n't been reviewed"
      succ = false
    end

    unless aa.empty?
      one_aa = aa.count == 1
      notify "#{aa.count} club#{one_aa ? " has" : "s have"} been accepted, but "\
        "ha#{one_aa ? "s" : "ve"}n't had their onboarding call "\
        "schedule#{one_aa ? "" : "s"} after a week!"
      succ = false
    end

    if succ
      notify "Congratulations <!subteam^S0DJXPY14|staff>! You've zeroed out "\
        'the club application pipeline! Good job.'
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
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
    unreviewed_applications
      .reject { |a| been_in_stage_for(a, 1.hour.ago) }
      .select do |a|
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
