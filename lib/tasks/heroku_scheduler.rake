namespace :heroku_scheduler do
  desc 'Schedule UpdateFromStreakJob'
  task queue_update_from_streak: :environment do
    UpdateFromStreakJob.perform_later
  end
end
