module Hackbot
  module Conversations
    class Help < Hackbot::Conversations::Channel
      copy_source 'help'

      def self.should_start?(event, team)
        event[:text].include?('help') && mentions_name?(event, team)
      end

      def start(_event)
        msg_channel copy('help')

        :finish
      end
    end
  end
end
