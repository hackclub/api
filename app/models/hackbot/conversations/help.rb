module Hackbot
  module Conversations
    class Help < Hackbot::Conversations::Channel
      HELP_MENU = "Hi! I'm Hack Club's friendly robot helper. I don't do "\
                  "much right now, but if you're a club leader you've "\
                  'probably received some messages from me about the '\
                  "attendance of your club.\n"\
                  "\n"\
                  "If you're interested in contributing to my codebase check "\
                  "out https://github.com/hackclub/api/issues. I'd love to "\
                  'learn some new tricks from you!'.freeze

      def self.should_start?(event, team)
        event[:text].downcase.include?('help') && mentions_name?(event, team)
      end

      def start(_event)
        msg_channel HELP_MENU

        :finish
      end
    end
  end
end
