# frozen_string_literal: true
class StatsService
  GRAPH_SAMPLES = 5

  attr_accessor :check_ins, :leader

  def initialize(leader)
    @leader = leader
    @check_ins = ::CheckIn.where(leader: leader).order('meeting_date ASC')
  end

  def attendance
    get_values :attendance
  end

  def meeting_dates
    get_values :meeting_date
  end

  def total_meetings_count
    @check_ins.length
  end

  def average_attendance
    @check_ins.average :attendance
  end

  def days_alive
    first_meeting = @check_ins.first.meeting_date

    (Time.zone.today - first_meeting).to_i
  end

  def club_name
    @leader.clubs.first.name
  end

  private

  def get_values(attribute)
    # We reverse the check-ins twice so we limit from the most recent check-ins
    # side of the list
    @check_ins
      .reverse_order # Most recent check-ins are now first
      .limit(GRAPH_SAMPLES)
      .pluck(attribute)
      .reverse # Oldest check-ins are now first
  end
end
