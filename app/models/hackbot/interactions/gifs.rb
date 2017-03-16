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
          attach_channel(text: copy('start.valid'), image_url: gif[:url])
        end
      end
    end
  end
end
