module Hackbot
  module Interactions
    class Welcome < TextConversation
      include Concerns::Triggerable

      def start
        msg_channel copy('welcome')
      end
    end
  end
end
