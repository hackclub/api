module Hackbot
  module Interactions
    class Command < TextConversation
      class << self
        def should_start?(event, team)
          # We have to use self:: to access the constant because of the quirk
          # described in this StackOverflow question:
          #
          # http://stackoverflow.com/q/42779998/1001686
          trigger = self::TRIGGER
          mention_regex = Hackbot::Utterances.name(team)

          event[:text] =~ /^#{mention_regex} #{trigger}$/
        end
      end

      def captures(event)
        @captures ||= self.class::TRIGGER.match(event[:text])
      end
    end
  end
end
