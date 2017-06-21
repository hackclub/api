module Hackbot
  module Interactions
    class Welcome < TextConversation
      include Concerns::Triggerable, Concerns::LeaderAssociable

      def start
        first_name = leader.name.split(' ').first

        msg_channel copy('welcome', name: first_name)
      end
    end
  end
end
