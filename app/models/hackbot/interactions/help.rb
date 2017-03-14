module Hackbot
  module Interactions
    class Help < Command
      TRIGGER = /help/

      def start(_event)
        msg_channel copy('help')

        :finish
      end
    end
  end
end
