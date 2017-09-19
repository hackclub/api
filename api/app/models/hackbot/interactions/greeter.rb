module Hackbot
  module Interactions
    class Greeter < TextConversation
      DEFAULT_CHANNEL = 'C756EH6VA'.freeze

      def should_start?
        event[:channel] == DEFAULT_CHANNEL &&
          event[:type] == 'message' &&
          event[:subtype] == 'channel_join'
      end

      def start
        im = SlackClient::Chat.open_im(event[:user], access_token)

        SlackClient::Chat.send_msg(
          im[:channel][:id],
          copy('greeting'),
          access_token,
          as_user: true
        )
      end
    end
  end
end
