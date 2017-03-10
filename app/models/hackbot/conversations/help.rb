module Hackbot
  module Conversations
    class Help < Hackbot::Conversations::Channel
      def self.should_start?(event, team)
        event[:type].eql?('message') &&
          event[:text].downcase.include?('help') && mentions_name?(event, team)
      end

      def start(_event)
        msg_channel copy('help')

        :finish
      end
    end
  end
end
