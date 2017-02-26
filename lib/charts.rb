module Charts
  class << self
    def attendance(leader)
      check_ins = ::CheckIn.where(leader: leader).order('meeting_date DESC').limit(4)
      data = check_ins.pluck :attendance

      g = Gruff::Line.new

      g.labels = {
        0 => 'first meeting',
        1 => 'second meeting',
        2 => 'third meeting',
        3 => 'fourth meeting'
      }

      g.minimum_value = 0
      g.maximum_value = data.max

      g.data('Your Club', data)

      g.to_blob
    end
  end
end
