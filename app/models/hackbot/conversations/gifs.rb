module Hackbot
  module Conversations
    class Gifs < Hackbot::Conversations::Channel
      def self.should_start?(event, team)
        event[:text].downcase.include?('gif') && mentions_name?(event, team)
      end

      def start(event)
        query = event_to_query event
        if query.empty?
          msg_channel copy('start.invalid')

          return :finish
        end

        try_sending_gif(query)
      end

      private

      def try_sending_gif(query)
        gif = GiphyClient.translate query

        if gif.nil?
          msg_channel copy('start.not_found')
        else
          send_gif(copy('start.valid'), gif[:url])
        end
      end

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
