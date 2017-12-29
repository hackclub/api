# frozen_string_literal: true
module Hackbot
  module Interactions
    class Gifs < Command
      TRIGGER = /gif ?(?<query>.+)?/

      USAGE = 'gif <query>'.freeze
      DESCRIPTION = 'find a GIF for the given query'.freeze

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
        gif = GuggyClient.translate query

        if gif.nil?
          msg_channel copy('start.not_found')
        else
          attach_channel(
            image_url: gif[:url],
            footer: copy('start.valid.text'),
            fallback: copy('start.valid.fallback')
          )
        end
      end
    end
  end
end
