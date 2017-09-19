module Hackbot
  module Interactions
    class Greeter < TextConversation
      DEFAULT_CHANNEL='C756EH6VA'

      def should_start?
        event[:channel] == DEFAULT_CHANNEL &&
          event[:type] == 'message' &&
          event[:subtype] == 'channel_join'
      end

      def start
        id = SlackClient::Chat.open_im(event[:user], access_token)[:channel][:id]

        SlackClient::Chat.send_msg(
          id,
          copy('greeting'),
          access_token,
          as_user: true
        )
      end
    end
  end
end
