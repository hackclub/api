# frozen_string_literal: true
module Hackbot
  module Interactions
    class Mention < TextConversation
      def should_start?
        msg =~ Hackbot::Utterances.name(team) && super
      end

      def start
        msg_channel 'Did someone mention me?'

        :wait_for_resp
      end

      def wait_for_resp
        if msg =~ Hackbot::Utterances.no
          msg_channel 'Oh, I see... :slightly_frowning_face:'
        elsif msg =~ Hackbot::Utterances.yes
          msg_channel "Oh my! I'm so glad to hear... I was getting a little "\
                      'worried for a moment there.'
        end

        :finish
      end
    end
  end
end
