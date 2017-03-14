module Hackbot
  module Interactions
    class Help < Command
      TRIGGER = /help/

      def start
        msg_channel copy('help')
      end
    end
  end
end
