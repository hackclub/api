module Hackbot
  module Interactions
    class Command < Channel
      class << self
        def should_start?(event, team)
          # We have to use self:: to access the constant because of the quirk
          # described in this StackOverflow question:
          #
          # http://stackoverflow.com/q/42779998/1001686
          trigger = self::TRIGGER

          event[:text] =~ /^#{username_regex(team)} #{trigger}$/
        end

        private

        def username_regex(team)
          /(<@#{team.bot_user_id}>|#{team.bot_username})/
        end
      end

      def captures(event)
        @captures ||= self.class::TRIGGER.match(event[:text])
      end
    end
  end
end
