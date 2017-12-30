# frozen_string_literal: true
module Charts
  class << self
    def as_file(g)
      temp = Tempfile.new
      temp.binmode
      temp.write g.to_blob
      temp.rewind

      temp
    end

    def bar(numbers, labels)
      g = Gruff::Bar.new

      style g

      g.minimum_value = 0
      g.maximum_value = numbers.max
      g.sort = false

      g.data('Club Attendance', numbers)

      labels.each_with_index do |v, i|
        g.labels[i] = v
      end

      g
    end

    private

    def style(g)
      g.hide_title = true
      g.hide_legend = true
      g.theme = {
        colors: ['white'],
        marker_color: 'white',
        font_color: 'white',
        background_colors: '#e42d40'
      }
    end
  end
end
