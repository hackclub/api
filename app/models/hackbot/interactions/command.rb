module Hackbot
  module Interactions
    class Command < TextConversation
      def self.usage(event, team)
        new(event: event, team: team).usage
      end

      def self.description(event, team)
        new(event: event, team: team).description
      end

      def should_start?
        # We have to use self.class:: to access the constant because of the
        # quirk described in this StackOverflow question:
        #
        # http://stackoverflow.com/q/42779998/1001686
        trigger = self.class::TRIGGER
        mention_regex = Hackbot::Utterances.name(team)

        if in_dm?
        then msg =~ /^(#{mention_regex} )?#{trigger}$/ && super
        else msg =~ /^#{mention_regex} #{trigger}$/ && super
        end
      end

      def captured
        @_captured ||= self.class::TRIGGER.match(msg)
      end

      def usage
        self.class::USAGE if self.class.const_defined? 'USAGE'
      end

      def description
        self.class::DESCRIPTION if self.class.const_defined? 'DESCRIPTION'
      end

      private

      # Returns whether we're currently in a direct message.
      #
      # If the channel ID starts with a D on Slack, then you're in a DM.
      def in_dm?
        event[:channel].start_with? 'D'
      end
    end
  end
end
