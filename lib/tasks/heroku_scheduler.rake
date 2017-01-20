namespace :heroku_scheduler do
  desc 'Schedule UpdateFromStreakJob'
  task queue_update_from_streak: :environment do
    UpdateFromStreakJob.perform_later
  end

  desc 'Schedule UpdateHackbotSlackUsernameJob'
  task queue_update_hackbot_slack_username: :environment do
    UpdateHackbotSlackUsernameJob.perform_later
  end
end
