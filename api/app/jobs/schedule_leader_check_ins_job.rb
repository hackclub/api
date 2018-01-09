# frozen_string_literal: true

# Schedule LeaderCheckInJob for leaders in each timezone.
class ScheduleLeaderCheckInsJob < ApplicationJob
  queue_as :default

  HACK_CLUB_TEAM_ID = 'T0266FRGM'
  CLUB_ACTIVE_STAGE_KEY = '5003'
  CLUB_INDIA_STAGE_KEY = '5020'
  CLUB_PIPELINE_KEY = Rails.application.secrets.streak_club_pipeline_key
  LEADER_ACTIVE_STAGE_KEY = '5006'
  LEADER_INDIA_STAGE_KEY = '5008'
  LEADER_PIPELINE_KEY = Rails.application.secrets.streak_leader_pipeline_key

  def perform(real_run = false, timezones = true)
    @dry_run = !real_run
    dry_run_notification if @dry_run

    close_check_ins

    pocs.each do |poc|
      trigger_time = time_offset(poc[:latitude], poc[:longitude])

      schedule_check_in(timezones, trigger_time, poc.streak_key)
    end

    Rails.logger.info "Scheduled #{pocs.count} check ins."
  end

  private

  def close_check_ins
    log('Closing currently open check ins')

    sleep 3.seconds

    CloseCheckInsJob.perform_now unless @dry_run
  end

  def dry_run_notification
    Rails.logger.info 'Running in dry run mode. This will not create '\
                      'scheduled jobs.'
    sleep 5.seconds
  end

  def schedule_check_in(timezones, trigger_time, streak_key)
    log("Scheduling check-in at #{trigger_time} for #{streak_key}")

    return if @dry_run

    job = if timezones
            LeaderCheckInJob.set(wait_until: trigger_time)
          else
            LeaderCheckInJob
          end

    job.perform_later(streak_key)
  end

  def log(message)
    Rails.logger.info((@dry_run ? '(Dry run) ' : '') + message)
  end

  def time_offset(lat, lng, day = 'friday', local_time = 17.hours)
    runtime_day = Date.parse(day)
    next_runtime = runtime_day + local_time
    Timezone.lookup(lat, lng).local_to_utc(next_runtime)
  rescue Timezone::Error::InvalidZone
    Rails.logger.warn 'Timezone invalid, defaulting to PST'
    Timezone.fetch('America/Los_Angeles').local_to_utc(next_runtime)
  end

  def active?(leader)
    leader_box = Leader.find_by(streak_key: leader.streak_key,
                                stage_key: LEADER_ACTIVE_STAGE_KEY) ||
                 Leader.find_by(streak_key: leader.streak_key,
                                stage_key: LEADER_INDIA_STAGE_KEY)

    !leader_box.nil?
  end

  def pocs
    # This returns all active club leaders at active clubs labeled as a point of
    # contact
    Club.where(stage_key: CLUB_ACTIVE_STAGE_KEY)
        .or(Club.where(stage_key: CLUB_INDIA_STAGE_KEY))
        .reject { |clb| (clb[:point_of_contact_id]).nil? }
        .map(&:point_of_contact)
        .select { |ldr| active? ldr }
        .select { |ldr| ldr.slack_id.present? }
  end
end
