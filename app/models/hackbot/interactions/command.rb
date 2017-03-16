module Hackbot
  module Interactions
    class Command < TextConversation
      def should_start?
        # We have to use self.class:: to access the constant because of the
        # quirk described in this StackOverflow question:
        #
        # http://stackoverflow.com/q/42779998/1001686
        trigger = self.class::TRIGGER
        mention_regex = Hackbot::Utterances.name(team)

        msg =~ /^#{mention_regex} #{trigger}$/ && super
      end

      def captured
        @_captured ||= self.class::TRIGGER.match(msg)
      end
    end
  end
end
