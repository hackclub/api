module Hackbot
  module Conversations
    class Gifs < Hackbot::Conversations::Channel
      set_conversation 'gifs'

      def self.should_start?(event, team)
        event[:text].include?('gif') && mentions_name?(event, team)
      end

      def start(event)
        query = event_to_query event
        if query.empty?
          msg_channel copy('start.invalid')

          return :finish
        end

        gif = GiphyClient.translate query

        send_gif(copy('start.valid'), gif[:url])
      end

      private

      def event_to_query(event)
        event[:text]
          .sub(team[:bot_username], '')
          .sub("<@#{team[:bot_user_id]}>", '')
          .sub('gif', '').strip
      end

      def send_gif(text, url)
        SlackClient.rpc('chat.postMessage',
                        access_token,
                        channel: data['channel'],
                        as_user: true,
                        attachments: [
                          {
                            text: text,
                            image_url: url
                          }
                        ].to_json)
      end
    end
  end
end
