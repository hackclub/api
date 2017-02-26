module Charts
  class << self
    def attendance(leader, history=4)
      check_ins = ::CheckIn.where(leader: leader).order('meeting_date ASC').limit(history)
      data_attendance = check_ins.pluck :attendance
      data_dates = check_ins.pluck :meeting_date

      g = Gruff::Line.new

      g.minimum_value = 0
      g.maximum_value = data_attendance.max
      g.sort = false

      g.data(
        'Your Club',
        data_attendance
      )

      data_dates.each_with_index do |v, i|
        g.labels[i] = v
      end

      g.to_blob
    end
  end
end
