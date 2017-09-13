namespace :heroku_scheduler do
  desc 'Schedule UpdateFromStreakJob'
  task queue_update_from_streak: :environment do
    UpdateFromStreakJob.perform_later
  end

  desc 'Schedule UpdateHackbotSlackUsernameJob'
  task queue_update_hackbot_slack_username: :environment do
    UpdateHackbotSlackUsernameJob.perform_later
  end

  desc 'Schedule RecordSlackStatsJob'
  task queue_record_slack_stats: :environment do
    RecordSlackStatsJob.perform_later
  end

  desc 'Schedule RecordSlackStatsJob'
  task queue_record_slack_stats: :environment do
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
    OpsAccountabilityJob.perform_later
  end

  desc 'Schedule CollectProjectsShippedJob'
  task queue_collect_projects_shipped_job: :environment do
    CollectProjectsShippedJob.perform_later
  end

  desc 'Schedule check-ins'
  task queue_schedule_check_ins: :environment do
    ScheduleLeaderCheckInsJob.perform_now true
  end

  desc 'Close check-ins'
  task queue_close_check_ins: :environment do
    CloseCheckInsJob.perform_now
  end
end
