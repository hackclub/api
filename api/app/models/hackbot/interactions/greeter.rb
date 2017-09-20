module Hackbot
  module Interactions
    class Greeter < TextConversation
      DEFAULT_CHANNEL = 'C74HZS5A5'.freeze

      def should_start?
        event[:channel] == DEFAULT_CHANNEL &&
          event[:type] == 'message' &&
          event[:subtype] == 'channel_join'
      end

      def start
        delete_event

        im = SlackClient::Chat.open_im(event[:user], access_token)

        return unless im[:ok]

        return if im[:already_open]

        SlackClient::Chat.send_msg(
          im[:channel][:id],
          copy('greeting'),
          access_token,
          as_user: true
        )
      end

      private

      def delete_event
        interaction = Hackbot::Interactions::DeleteJoins.create(
          event: event,
          team: team
        )

        interaction.handle
        interaction.save!
        interaction
      end
    end
  end
end
