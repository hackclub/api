module Hackbot
  module Interactions
    class Accountability < Command
      TRIGGER = /accountability/

      USAGE = 'accountability'.freeze
      DESCRIPTION = 'find out how far behind the team is in responding to applications'.freeze

      def start
        OpsAccountabilityJob.perform_now(data['channel'])
      end
    end
  end
end
