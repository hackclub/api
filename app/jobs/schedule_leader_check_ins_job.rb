# Schedule LeaderCheckInJob for leaders in each timezone.
class ScheduleLeaderCheckInsJob < ApplicationJob
  HACK_CLUB_TEAM_ID = 'T0266FRGM'.freeze
  CLUB_ACTIVE_STAGE_KEY = '5003'.freeze
  CLUB_PIPELINE_KEY = Rails.application.secrets.streak_club_pipeline_key
  LEADER_ACTIVE_STAGE_KEY = '5006'.freeze
  LEADER_PIPELINE_KEY = Rails.application.secrets.streak_leader_pipeline_key

  def perform
    pocs.each do |poc|
      trigger_time = time_offset(poc[:latitude], poc[:longitude])

      LeaderCheckInJob.set(wait_until: trigger_time).perform_later streak_key
    end
  end

  private

  def time_offset(lat, lng, day = 'friday', local_time = 17.hours)
    runtime_day = Date.parse(day)
    next_runtime = runtime_day + local_time
    Timezone.lookup(lat, lng).local_to_utc(next_runtime)
  end

  def active_club_boxes
    @club_active_boxes ||= StreakClient::Box
                           .all_in_pipeline(CLUB_PIPELINE_KEY)
                           .select do |b|
      b[:stage_key] == CLUB_ACTIVE_STAGE_KEY
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

  def pocs
    # This returns all active club leaders at active clubs labeled as a point of
    # contact
    active_club_boxes
      .map { |box| Club.find_by(streak_key: box[:key]) }
      .select { |clb| !clb[:point_of_contact_id].nil? }
      .map(&:point_of_contact)
      .select { |ldr| active? ldr }
      .select { |ldr| ldr.slack_id.present? }
  end
end
