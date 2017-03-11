module Hackbot
  module Conversations
    class Help < Hackbot::Conversations::Channel
      def self.should_start?(event, team)
        event[:type].eql?('message') &&
          mentions_command?(event, team, 'help')
      end

      def start(_event)
        msg_channel copy('help')

        :finish
      end
    end
  end
end
