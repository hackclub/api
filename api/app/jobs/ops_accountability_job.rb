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

    a = unassigned_applications
    b = old_unreviewed_applications
    c = not_scheduled_applications
    succ = true

    unless a.empty?
      notify 'Currently ' + (a.count == 1 ? "there's 1 unassigned application."
        : "there are #{pluralize a.count, 'unassigned application'}.")
      succ = false
    end

    unless b.empty?
      x = b.count == 1 ? 'application that has' : pluralize(b.count, 'application') + ' that have'
      notify "Come on…go review the #{x} been around for like two days."
      succ = false
    end

    unless c.empty?
      if c.count == 1
        x = "is still an accepted club that hasn't had an onboarding call"
      else
        x = "are #{pluralize c.count, 'accepted club'} that haven't had onboarding calls"
      end
      notify "There #{x} scheduled after a week!"
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
