# frozen_string_literal: true

module Hackbot
  module Interactions
    class Welcome < TextConversation
      include Concerns::LeaderAssociable
      include Concerns::Triggerable

      def start
        first_name = leader.name.split(' ').first

        msg_channel copy('welcome', name: first_name)
      end
    end
  end
end
