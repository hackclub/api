module Hackbot
  module Interactions
    class DeleteJoins < Delete
      CHANNELS_WITH_JOINS_TO_DELETE = ['C0266FRGT'].freeze

      def should_start?
        CHANNELS_WITH_JOINS_TO_DELETE.include?(event[:channel]) &&
          event[:type] == 'message' &&
          event[:subtype] == 'channel_join'
      end
    end
  end
end
