class StatsService
  GRAPH_SAMPLES = 4

  attr_accessor :check_ins, :leader

  def initialize(leader)
    @leader = leader
    @check_ins = ::CheckIn.where(leader: leader).order('meeting_date ASC')
  end

  def attendance
    @check_ins.reverse_order.limit(GRAPH_SAMPLES).pluck(:attendance).reverse
  end

  def labels
    @check_ins.reverse_order.limit(GRAPH_SAMPLES).pluck(:meeting_date).reverse
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
end
