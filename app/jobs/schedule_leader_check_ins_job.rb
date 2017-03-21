# Schedule LeaderCheckInJob for leaders in each timezone.
class ScheduleLeaderCheckInsJob < ApplicationJob
  HACK_CLUB_TEAM_ID = 'T0266FRGM'.freeze
  CLUB_ACTIVE_STAGE_KEY = '5003'.freeze
  CLUB_INACTIVE_ONE_WEEK_KEY = '5012'.freeze
  CLUB_INACTIVE_TWO_WEEKS_KEY = '5013'.freeze
  CLUB_PIPELINE_KEY = Rails.application.secrets.streak_club_pipeline_key
  LEADER_ACTIVE_STAGE_KEY = '5006'.freeze
  LEADER_PIPELINE_KEY = Rails.application.secrets.streak_leader_pipeline_key

  CLUB_ACTIVE_STAGE_KEYS = [CLUB_ACTIVE_STAGE_KEY, CLUB_INACTIVE_ONE_WEEK_KEY,
                            CLUB_INACTIVE_TWO_WEEKS_KEY].freeze

  def perform(real_run = false, timezones = true)
    dry_run_notification unless real_run
    pocs.each do |poc|
      trigger_time = time_offset(poc[:latitude], poc[:longitude])

      schedule_check_in(real_run, timezones, trigger_time, poc.streak_key)
    end

    Rails.logger.info "Scheduled #{pocs.count} check ins."
  end

  private

  def dry_run_notification
    Rails.logger.info 'Running in dry run mode. This will not create '\
                      'scheduled jobs.'
    sleep 5.seconds
  end

  def schedule_check_in(real_run, timezones, trigger_time, streak_key)
    msg = (real_run ? '' : '(Dry run) ')
    msg << "Scheduling check-in at #{trigger_time} for #{streak_key}"
    Rails.logger.info msg

    return unless real_run

    job = if timezones
            LeaderCheckInJob.set(wait_until: trigger_time)
          else
            LeaderCheckInJob
          end

    job.perform_later(streak_key)
  end

  def time_offset(lat, lng, day = 'friday', local_time = 17.hours)
    runtime_day = Date.parse(day)
    next_runtime = runtime_day + local_time
    Timezone.lookup(lat, lng).local_to_utc(next_runtime)
  rescue Timezone::Error::InvalidZone
    Rails.logger.warn 'Timezone invalid, defaulting to PST'
    Timezone.fetch('America/Los_Angeles').local_to_utc(next_runtime)
  end

  def active_club_boxes
    @club_active_boxes ||= StreakClient::Box
                           .all_in_pipeline(CLUB_PIPELINE_KEY)
                           .select do |b|
                             CLUB_ACTIVE_STAGE_KEYS.include? b[:stage_key]
                           end

    @club_active_boxes
  end

  def active_leader_boxes
    @leader_active_boxes ||= StreakClient::Box
                             .all_in_pipeline(LEADER_PIPELINE_KEY)
                             .select do |b|
      b[:stage_key] == LEADER_ACTIVE_STAGE_KEY
    end

    @leader_active_boxes
  end

  def active?(leader)
    leader_box = active_leader_boxes.find do |box|
      box[:key].eql? leader.streak_key
    end

    !leader_box.nil?
  end

  # rubocop:disable Metrics/AbcSize
  def pocs
    # This returns all active club leaders at active clubs labeled as a point of
    # contact
    active_club_boxes
      .map { |box| Club.find_by(streak_key: box[:key]) }
      .select { |clb| !clb.nil? }
      .select { |clb| !(clb[:point_of_contact_id]).nil? }
      .map(&:point_of_contact)
      .select { |ldr| active? ldr }
      .select { |ldr| ldr.slack_id.present? }
  end
  # rubocop:enable Metrics/AbcSize
end
