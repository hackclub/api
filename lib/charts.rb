module Charts
  class << self
    def as_file(g)
      temp = Tempfile.new
      temp.binmode
      temp.write g.to_blob
      temp.rewind

      temp
    end

    def line_chart(numbers, labels)
      g = Gruff::Line.new

      g.minimum_value = 0
      g.maximum_value = numbers.max
      g.sort = false

      g.data('Your Club', numbers)

      labels.each_with_index do |v, i|
        g.labels[i] = v
      end

      g
    end
  end
end
