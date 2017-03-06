module Hackbot
  module Conversations
    class Gifs < Hackbot::Conversations::Channel
      def self.should_start?(event, team)
        event[:text].downcase.include?('gif') && mentions_name?(event, team)
      end

      def start(event)
        query = event_to_query event
        if query.empty?
          msg_channel 'You need to provide a query, silly!'

          return :finish
        end

        gif = GiphyClient.translate query

        send_gif('A gif from Giphy!', gif[:url])
      end

      private

      def event_to_query(event)
        event[:text]
          .sub(/#{team[:bot_username]}/i, '')
          .sub(/<@#{team[:bot_user_id]}>/i, '')
          .sub(/gif/i, '').strip
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
