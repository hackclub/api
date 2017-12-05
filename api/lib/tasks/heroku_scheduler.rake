namespace :heroku_scheduler do
  desc 'Schedule UpdateFromStreakJob'
  task queue_update_from_streak_job: :environment do
    UpdateFromStreakJob.perform_later
  end

  desc 'Schedule UpdateHackbotSlackUsernameJob'
  task queue_update_hackbot_slack_username_job: :environment do
    UpdateHackbotSlackUsernameJob.perform_later
  end

  desc 'Schedule RecordSlackStatsJob'
  task queue_record_slack_stats_job: :environment do
    RecordSlackStatsJob.perform_later
  end

  desc 'Schedule HandleSpamClubApplicationsJob'
  task queue_handle_spam_club_applications_job: :environment do
    HandleSpamClubApplicationsJob.perform_later
  end

  desc 'Schedule ActivateClubsJob'
  task queue_activate_clubs_job: :environment do
    ActivateClubsJob.perform_later
  end

  desc 'Schedule OpsAccountabilityJob'
  task queue_ops_accountability_job: :environment do
    unless Time.zone.now.saturday? || Time.zone.now.sunday?
      OpsAccountabilityJob.perform_later
    end
  end

  desc 'Schedule CollectProjectsShippedJob'
  task queue_collect_projects_shipped_job: :environment do
    CollectProjectsShippedJob.perform_later
  end

  desc 'Schedule check-ins'
  task queue_schedule_leader_check_ins_job: :environment do
    # Heroku does not allow you to choose what day to run a job
    ScheduleLeaderCheckInsJob.perform_now true if Time.zone.now.thursday?
  end

  desc 'Close check-ins'
  task queue_close_check_ins_job: :environment do
    # Heroku does not allow you to choose what day to run a job
    CloseCheckInsJob.perform_now if Time.zone.now.monday?
  end
end
