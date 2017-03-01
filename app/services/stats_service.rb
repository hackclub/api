class StatsService
  GRAPH_SAMPLES=4

  def initialize(leader)
    @leader = leader
    @check_ins = ::CheckIn.where(leader: leader).order('meeting_date ASC')
  end

  def attendance
    @check_ins.limit(GRAPH_SAMPLES).pluck :attendance
  end

  def labels
    @check_ins.limit(GRAPH_SAMPLES).pluck :meeting_date
  end

  def total_meetings_count
    @check_ins.length
  end

  def total_average_attendance
    @check_ins.average :attendance
  end

  def days_alive
    first_meeting = @check_ins.first.meeting_date

    (Date.today - first_meeting).to_i
  end

  def club_name
    @leader.clubs.first.name
  end
end
