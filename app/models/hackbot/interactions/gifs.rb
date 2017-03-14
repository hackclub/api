module Hackbot
  module Interactions
    class Gifs < Command
      TRIGGER = /gif ?(?<query>.+)?/

      def start
        query = captured[:query]

        if query.present?
          try_sending_gif(query)
        else
          msg_channel copy('start.invalid')
        end
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
