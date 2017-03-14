module Hackbot
  module Interactions
    class DiceRoll < Command
      TRIGGER = /roll ?(?<side_count>.+)?/

      def start
        raw_side_count = captured[:side_count] || '6'

        integer?(raw_side_count) ? roll(raw_side_count.to_i) : bad_side_count
      end

      private

      def roll(side_count)
        msgs = [
          copy('roll_1', side_count: side_count),
          copy('roll_2'),
          copy('roll_3'),
          copy('roll_4', result: rand(1..side_count))
        ]

        msgs.each { |m| msg_channel(m) && sleep(0.5) }
      end

      def bad_side_count
        msg_channel copy('errors.bad_side_count')
      end

      def integer?(str)
        Integer(str) && true
      rescue ArgumentError
        false
      end
    end
  end
end
